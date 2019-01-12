//utils
!function() {
	var
		ERR_INVALID_CODE = 'invalid_code'
		,LOCALE_ERR_SYNTAX = "数据格式错误"
		,LOCALE_ERR_404 = '无法访问，请检查您的网络'
		,is_bad_request = function(status) {
			return (status===403 || status===404);
		}
		,is_valid_code = function(code) {
			var c = parseInt(code);
			return (!isNaN(c)) && (c == 0);
		}
		,common_response_logics = function(data) {
			var rst = data.result;
			if (rst === null || typeof rst === 'undefined') {
				rst = {};
			}
			//加载更多等不跳到页头
			if (!(rst.hasOwnProperty('isInPageAjax') && rst.isInPageAjax)) {
				app.utils.page_to_top();
			}
			//通用alert提示
			if (rst.hasOwnProperty('alert') && $.isPlainObject(rst.alert)) {
				app.utils.alert({
					content: [
						'<i class="'
						,app.utils.status(rst.alert.type)
						,'"></i>'
						,rst.alert.msg
					].join('')
					,onclick: function(){
						if (rst.alert.close_page) {
							if (typeof WeixinJSBridge !== 'undefined')
								WeixinJSBridge.call('closeWindow');
							else if (typeof wx !== 'undefined')
								wx.closeWindow();
							else
								history.go(-1); //TODO
						} else if (rst.alert.reflush) {
							location.reload();
						}
					}
				});
				return true;
			}
			//跳转
			if (rst.hasOwnProperty('route')) {
				riot.route(rst.route);
				return true;
			}
		}
		,do_request = function(method) {
			return function(url, params, errCallback) {
				$.showLoading(app.i18n.loading);
				return $.ajax({
					type: method.toUpperCase()
					,url: (_app_config.ajax_prefix + url).replace(/([^\:])\/+/g, "$1/").replace(/\/$/, '')
					,data: params
					,dataType: 'json'
					,withCredentials: true
				}).then(function(data, status, xhr) {
					if (is_bad_request(status)) {
						try{
							riot.route('msg/'+data.errcode+'/'+LOCALE_ERR_404);
						}catch(ex){
							alert(LOCALE_ERR_404);
						}
					} else if (is_valid_code(data.errcode)) {
						if (common_response_logics(data)) return;
						return data.result;
					} else {
						if (common_response_logics(data)) return;
						if ($.isFunction(errCallback)) {
							errCallback.call(null, data);
						} else {
							riot.route('msg/'+data.errcode+'/'+ (encodeURI(data.errmsg)||'unknown%20error') );
						}
					}
					return data;
				}).fail(function(xhr, errorType, error) {
					if (error instanceof SyntaxError) {
						console.log(error);
						riot.route('msg/1/'+LOCALE_ERR_SYNTAX);
					} else {
						//common_response_logics(data);
						riot.route('msg/'+errorType+'/'+encodeURI(error));
					}
				}).always(function() {
					$.hideLoading();
				});
			};
		}
	;

	var _last_tag = null;

	/**
	 * @namespace
	 * @name app
	 * @type {Object}
	 */
	
	/**
	 * @memberOf app
	 */
	var utils = {
		/**
		 * @private
		 */
		load_page: function(cfg, page) {
			var _this = utils;
			return function() {
				var
					root_id = cfg.root_id
					,context = '#'+root_id+'>div'
					,page_id = page.replace(/\//g, '_')
					//路由规则参数数组 -> [arg...]
					,args = [].slice.call(arguments, 0).filter(function(arg){
						return arg && !/^\/+/.test(arg); //过滤正则中路由可选部分造成的多余参数
					}).map(function(arg){
						return arg.replace(/(\&.*)+$/, ''); //过滤后面的附加参数
					})
					//路由后附加的参数数组 -> ['&key=value'...]
					,params = riot.route.query()
					//avoid context err
					,new_one = '<div></div>';
				document.getElementById(root_id).innerHTML = new_one;
				_this.load_tag(page, {
					id: page_id
					,args: args
					,params: params
				}, context, function() {
					_last_tag && _last_tag[0].trigger('destruct'); //析构函数
				}, function(tag) {
					_last_tag = riot.observable(tag); 
				});
				//附加相应的样式
				document.body.className = 'page_' + page_id;
				document.documentElement.className = 'root_' + page_id;
				console.log('page "%s" has loaded', page_id);
				if ('onPageChangeHook' in window && typeof window.onPageChangeHook === 'function') {
					window.onPageChangeHook(page);
				}
			};
		},
		/**
		 * @private
		 */
		load_routes: function(cfg, callback) {
			var _this = utils;
			return function() {
				var 
					dft = app_router["default"]
					,map = {}
					,keys
				;
				$.each(app_router.rules, function(key, val) {
					map[key] = _this.load_page(cfg, val);
				});
				keys = Object.keys(map);
				riot.route.base(ROUTE_BASE_CHAR);
				if (keys.length) {
					keys.forEach(function(rule, idx){
						riot.route(rule, map[rule]);
					});
					riot.route(map[dft]);
				}
				callback(function(){
					riot.route.start(true);
				});
			};
		},
		/**
		 * 动态加载一个tag
		 * @param  {String} tagPath - tag名（不包含路径和扩展名）
		 * @param  {Object} opts - 参数
		 * @param  {String} [selector=null] - css选择器
		 * @return {void}
		 */
		load_tag: function(tagPath, opts, selector, beforeCallback, afterCallback) {
			var
				my_opts = $.extend({
					utils: app.utils
					,i18n: app.i18n
				}, opts)
				,load = function() {
					beforeCallback && beforeCallback();
					var tag = selector
						? riot.mount(selector, tagPath, my_opts)
						: riot.mount(tagPath, my_opts);
					afterCallback && afterCallback(tag);
				}
			;
			if (_develop_env === 'build')
				load();
			else
				riot.compile('/tags/'+tagPath+'.tag', load);
		},
		/**
		 * 自带默认处理逻辑的ajax GET方法
		 * @param {String} url - 不包含prefix的请求路径
		 * @param {Object} [params=null] - 请求参数
		 * @param {Function} [errCallback=null] - 自定义的错误处理函数
		 * @return {Promise}
		 */
		do_get: do_request('get'),
		/**
		 * 自带默认处理逻辑的ajax POST方法
		 * @param {String} url - 不包含prefix的请求路径
		 * @param {Object} [params=null] - 请求参数
		 * @param {Function} [errCallback=null] - 自定义的错误处理函数
		 * @return {Promise}
		 */
		do_post: do_request('post'),
		/**
		 * 映射操作结果的状态字符串，用于弹窗和消息页等
		 * @param  {Number} code - 0 'success' | 1 'warn'
		 * @return {String}
		 */
		status: function(code) {
			return code == '0' ? 'success' : 'warn';
		},
		/**
		 * 弹出提示
		 * @param  {Object} [options={title, content, buttonText, onclick}]
		 * @return {void}
		 */
		alert: function(options) {
			var opt = $.extend({
				title: ''
				,buttonText: app.i18n.alert.button_text
				,onclick: $.noop
			}, options);
			$.modal({
				title: opt.title,
				text: opt.content,
				buttons: [
					{
						text: opt.buttonText,
						onClick: opt.onclick
					}
				]
			});
		}
	};

	//https://www.npmjs.com/package/mobile-utils
	var mUtils = window['mobile-utils'];
	app.utils = $.extend({}, utils, mUtils, mUtils.utils);
}();