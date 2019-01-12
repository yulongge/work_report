<account class="cell" id={opts.id}>
	<div class="current-account">
		<span class="account-txt">{ $k.login_account }</span>
		<span class="account-num">{ $cfg.account }</span>
	</div>

	<a href="javascript:void(0);"
		class="logout"
		onClick={ this.logout }>{ $k.btn_logout }</a>

	<script>
		var
			args = opts.args
			,params = opts.params
			,utils = opts.utils
			,i18n = opts.i18n
			,_this = this
			,data
		;

		utils.do_get('/account').then(
			function(rst) {
				data = rst;
				_this.update({
					$cfg: rst,
					$k: i18n.account
				});
			}
		);

		this.logout = function() {
			utils.do_post('/logout', data.account);
		}
	</script>

	<style type="text/less">
	@import "../less/vars";
	@import "../less/functions";
	@import "../less/less-rem";
	@import "../less/rem-weui";
	@import "../less/global";

	#account {
		.px2rem(40px, padding-top);
	}

	.current-account {
		.px2rem(60px, margin-bottom);
		.px2rem(120px, height);
		.px2rem(120px, line-height);
		background: #fff;
	}

	.account-txt {
		float: left;
		.px2rem(30px, padding-left);
		.px2rem(32px, font-size);
		color: #999;
	}

	.account-num {
		float: right;
		.px2rem(30px, padding-right);
		.px2rem(36px, font-size);
	}

	.logout {
		display: block;
		.px2rem(130px, margin-left);
		.px2rem(130px, margin-right);
		.px2rem(100px, height);
		.px2rem(100px, line-height);
		.px2rem(40px, font-size);
		text-align: center;
		color: #fff;
		border-radius: 7px;
		background: #2b2;
	}
	</style>

</account>
