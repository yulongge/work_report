<login class="cell" id={opts.id}>

	<div class="weui_cells_title">{ $k.title }</div>
	<form name="form1" onsubmit="return false">
		<ul class="weui_cells weui_cells_form">
			<li class="weui_cell">
				<div class="weui_cell_hd"><label class="weui_label">{ $k.label_account }</label></div>
				<div class="weui_cell_bd">
					<input class="weui_input" type="tel" name="account" autocomplete="off"
						pattern="{ $cfg.pattern_account }"
						data-mismatch="{ $cfg.mismatch_account }"
						data-missing="{ $cfg.missing_account }"
						placeholder="{ $k.placeholder_account }" 
						required />
				</div>
			</li>
			<li class="weui_cell">
				<div class="weui_cell_hd"><label class="weui_label">{ $k.label_password }</label></div>
				<div class="weui_cell_bd">
					<input class="weui_input" type="password" name="password"  
						pattern="{ $cfg.pattern_password }"
						data-mismatch="{ $cfg.mismatch_password }"
						data-missing="{ $cfg.missing_password }"
						placeholder="{ $k.placeholder_password }" 
						required />
				</div>
			</li>
		</ul>
		<app-button class="submit">{ parent.$k.btn_login }</app-button>
	</form>
	<footer>
		<figure></figure>
		<p><raw content={ $k.label_footer } /></p>
	</footer>

	<script>
		var
			args = opts.args
			,params = opts.params
			,utils = opts.utils
			,i18n = opts.i18n
			,_this = this
		;
		this.update({
			$cfg: app.init_data.login, 
			$k: i18n.login
		});
		this.on('update', function() {
			utils.form_primary_valid(
				this.form1,
				function(from, fields) {
					utils.do_post('/login', fields);
				},
				$.alert
			);
		});
	</script>

	<style type="text/less">
	@import "../less/vars";
	@import "../less/functions";
	@import "../less/less-rem";
	@import "../less/rem-weui";
	@import "../less/global";
	@import "../less/mods";

	.page_login {
		.px2rem(120px, padding-bottom);
		ul {
			margin-top: 0;
		}
		footer {
			display: flex;
			justify-content: center;
			align-items: center;
			position: fixed;
			width: 100%;
			bottom: 0;
			left: 0;
			.px2rem(120px, height);
			background: #F6F5F9;

			figure {
				.px2rem(90px, width);
				.px2rem(66px, height);
				background: url('@{img}tel.png') no-repeat 0 0;
				.bg-size(contain);
				border-right: solid #DDDDE2;
				.px2rem(1px, border-right-width);
			}
			p {
				.px2rem(20px, padding-left);
				.px2rem(24px, font-size);
				color: rgba(0,0,0,.4);
				.px2rem(40px, line-height);
				a {
					display: block;
					color: #09BB07;
				}
			}
		}
	}
	</style>

</login>