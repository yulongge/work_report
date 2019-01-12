<msg class="weui_msg" id={opts.id}>
	<div class="weui_icon_area"><i
		class="weui_icon_{type} weui_icon_msg"
		rel={errcode}></i></div>
	<div class="weui_text_area">
		<h2 class="weui_msg_title">{decodeURIComponent(errmsg)}</h2>
		<p class="weui_msg_desc" if={typeof detail !== 'undefined'}>
			{ detail ? decodeURIComponent(detail) : null }
		</p>
	</div>
	<div class="weui_opr_area" if={btns}>
		<p class="weui_btn_area">
			<virtual each={btns}>
				<app-button
					route={route}
					type={type||0} >
						{label}
				</app-button>
			</virtual>
		</p>
	</div>

	<script>
		//basic infos
		var
			args = opts.args
			,params = opts.params
			,data = {
				errcode: args[0]
				,errmsg: args[1]
				,detail: args.length<3 ? void(0) : args[2]
				,type: opts.utils.status(args[0])
			}
		;
		//buttons
		if (params.length) {
			var b = $.grep(params, function(item) {
				return /^btn\d+\=/.test(item);
			});
			if (b.length) {
				var btns = b.slice();
				btns = btns.map(function(item) {
					var
						arr = item.split('=')[1].split('|')
						,label = arr[0]
						,type = arr.length>1 ? arr[1] : null
						,route = arr.length>2 ? arr[2] : null
					;
					return {label:label, type:type, route:route};
				});
				data = $.extend({}, data, {btns:btns});
			}
		}
		this.update(data);
		//TODO detail & btns
	</script>

	<style>
	@import "../less/less-rem";
	@import "../less/rem-weui";
	</style>
</msg>