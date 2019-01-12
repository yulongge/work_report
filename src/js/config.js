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
