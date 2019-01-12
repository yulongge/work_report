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