var _develop_env='init';

var
	ROUTE_BASE_CHAR = '#'
	,app = {}
	,app_router = {
		"default": 'main',
		rules: {
			/**
			 * 通用成功失败提示页
			 * @param {Number} errcode
			 * @param {String} msg
			 * @param {Stromg} detail
			 * @param {String} [btns=''] - 可选的若干个按钮
			 * @example #msg/<errcode>/<msg>/<detail>&btn0=<label>|<type>|<route>&btn1=<label>|<type>|<route>...
			 */
			'msg/*/*(/*)?': 'msg'
			/**
			 * 登录
			 */
			,'login': 'login'
			/**
			 * 当前账号
			 */
			,'account': 'account'
			/**
			 * 无权限
			 */
			,'access': 'access'
			/**
			 * 选择日期页
			 */
			,'timerange..': 'timerange'
			/**
			 * 经营报告主页
			 * 可选参数time - #main&time=2016-08-01,2016-08-31
			 */
			,'main': 'main'
			,'main..': 'main'
			/**
			 * 门店排行页
			 */
			,'ranking': 'ranking'
			,'ranking..': 'ranking'
			/**
			 * 切换绑定的多个商家
			 */
			,'shops..': 'shops'
		}
	};


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

//i18n
!function() {
	app.i18n = {
		err_required: '请输入{0}'
		,loading: '正在加载...'
		,time_from_to: '{0} 至 {1}'
		,load_more: '点击加载更多'
		,alert: {
			button_text: '我知道了'
		}
		/*登录*/
		,login: {
			title: '使用微生活商户中心账号登录',
			label_forgot: '忘记密码？',
			label_account: '账 号',
			placeholder_account: '请输入注册的手机号',
			label_password: '密 码',
			placeholder_password: '请输入密码',
			btn_login: '登录',
			label_footer: '微生活会员营销服务热线<a href="tel:400-600-7660">400-600-7660</a>'
		}
		/*当前账号*/
		,account: {
			login_account: '当前登录账号',
			btn_logout: '登出'
		}
		/*当前账号*/
		,access: {
			noaccess: '当前账号没有权限查看数据中心'
		}
		/*选择时间范围*/
		,time: {
			title: '切换日期',
			label_today: '今天',
			label_yesterday: '昨天',
			label_to: '至',
			btn_login: '确定'
		}
		/*主页(报表)*/
		,main: {
			toggle_time: '切换日期',
			toggle_shop: '切换',
			label_chart: '报表',
			label_rank: '排行榜'
		}
		,ranking: {
			rank: '排名'
		}
		,shops: {
			shops_select: '{0}绑定了多个商家账号，请选择'
		}

	};
}();


//common components
function mount_common() {
	/**
	 * 显示带HTML结构的内容
	 * @property {HTML} content
	 */
	riot.tag('raw', '', function(opts) {
		this.root.innerHTML = opts.content;
		this.on('update', function(){
			if (opts.content && opts.auto_update) this.mount();
		});
	});
	/**
	 * WEUI按钮
	 * @property {String} [route=undefined] - 指定应用内路由跳转
	 * @property {Number} [type=0] - 0:primary|1:default|2:warn
	 * @property {Boolean} [mini=false] - 是否显示mini样式
	 * @property {Boolean} [disabled=false] 是否显示禁用样式, 并屏蔽route属性
	 */
	riot.tag('app-button'
		,'<a href={href} class={cls}><yield/></a>'
	,function(opts){
		var cls = 'weui_btn weui_btn_';
		cls += ['primary', 'default', 'warn'][opts.type||0];
		cls += (opts.mini ? ' weui_btn_mini' : '');
		cls += (opts.__disabled ? ' weui_btn_disabled' : '');
		var href = opts.route
			? opts.__disabled
				? 'javascript:;'
				: ROUTE_BASE_CHAR + opts.route
			: 'javascript:;';
		this.update({cls: cls, href: href});
	});
}

function start_app(callback) {
	window['less-rem'](50);
	var 
		cfg = $.extend({root_id: 'app-main'}, _app_config)
		load_r = app.utils.load_routes(cfg, callback)
	;
	//load app container
	app.utils.load_tag('app', {id: cfg.root_id});
	//init routes
	if (_develop_env === 'build') load_r();
	else riot.compile('/tags/app.tag', load_r);
}

//获得初始数据并启动应用
$(function() {
	//启动
	start_app(function(done) {
		mount_common();
		app.utils.do_get('').then(function(rst) {
			app.init_data = rst;
			done();
		});
	});
});

