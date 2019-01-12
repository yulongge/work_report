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