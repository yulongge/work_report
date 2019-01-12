<timerange class="cell" id={opts.id}>

	<div class="weui_cells_title head">
		<p>{ $k.title }</p>
		<a href="javascript:;" onClick={ make_today }>{ $k.label_today }</a>
		<a href="javascript:;" onClick={ make_yesterday }>{ $k.label_yesterday }</a>
	</div>
	<form name="form1" onsubmit="return false">
		<ul class="weui_cells weui_cells_form">
			<li class="weui_cell">
				<div class="weui_cell_bd field">
					<p id="tgr1">{yesterday}</p>
					<p class="to">{$k.label_to}</p>
					<p id="tgr2">{today}</p>
				</div>
			</li>
		</ul>
		<app-button onClick={ onsubmit }>{ parent.$k.btn_login }</app-button>
	</form>

	<script>
		/*if ( !(new RegExp(ROUTE_BASE_CHAR + 'time')).test(location.href) ) {
			this.unmount();
			return;
		}*/
		var
			args = opts.args
			,params = opts.params
			,utils = opts.utils
			,i18n = opts.i18n
			,tarr = params.curr
				? params.curr.split(',')
				: null
			,lCale = window['lunar-cale']
			,_this = this
			,_caleLock = false
			,_valid = true
			,enableBtn = function(bool) {
				var submit_btn = _this.form1.querySelector('.weui_btn');
				if (bool) {
					submit_btn.classList.add('weui_btn_primary');
					submit_btn.classList.remove('weui_btn_disabled');
					submit_btn.classList.remove('weui_btn_default');
				} else {
					submit_btn.classList.remove('weui_btn_primary');
					submit_btn.classList.add('weui_btn_disabled');
					submit_btn.classList.add('weui_btn_default');
				}
				submit_btn = null;
				_valid = bool;
			}
			,bindTriggerClick = function(which, idx) {
				var lc = new lCale({
					mode: lCale.SOLAR,
					startYear: 1970,
					endYear: moment().year(),
					initShownYMD: tarr
						? idx === 1
							? tarr[0]
							: tarr[1]
						: void(0),
					selectCallback: function(y,m,d,lunar) {
					},
					closeCallback: function(y,m,d,lunar) {
						_caleLock = false;   
						var target = idx === 1 ? 'yesterday' : 'today';
						var obj = {};
						obj[target] = [y,m,d].join('-');
						_this.update(obj);

						if (moment(_this.tgr1.innerHTML).valueOf() > moment().valueOf()
							|| moment(_this.tgr2.innerHTML).valueOf() > moment().valueOf()) {
							alert('最晚只能选择当天');
							enableBtn(false);
							return;
						}
						if (moment(_this.tgr1.innerHTML).valueOf() > moment(_this.tgr2.innerHTML).valueOf()) {
							alert('结束日期不可早于开始日期');
							enableBtn(false);
							return;
						}
						enableBtn(true);
					}
				});
				which.addEventListener('click', function(e) {
					if (_caleLock) return;
					_caleLock = true;
					lc.show();
				});
				_this.cale = lc;
			}
			,get_today = function() {
				return moment().format('YYYY-MM-DD');
			}
			,get_yesterday = function() {
				return moment().add(-1, 'days').format('YYYY-MM-DD')
			}
			,do_route = function(isFlush, time1, time2) {
				var r = isFlush
					? ['timerange&curr=', time1, ',', time2, '&from=', params.from]
					: [params.from, '&time=', time1, ',', time2];
				riot.route(r.join(''));
			}
		;

		this.update({
			$k: i18n.time,
			today: tarr ? tarr[1] : get_today(),
			yesterday: tarr ? tarr[0] : get_yesterday()
		});
		
		bindTriggerClick(this.tgr1, 1);
		bindTriggerClick(this.tgr2, 2);

		this.make_today = function(e) {
			do_route(true, get_today(), get_today());
		};
		this.make_yesterday = function(e) {
			do_route(true, get_yesterday(), get_yesterday());
		};

		this.onsubmit = function(e) {
			if (!_valid) return;
			do_route(false, _this.tgr1.innerHTML, _this.tgr2.innerHTML)
		};

		this.on('destruct', function() {
			_this.cale && _this.cale.hide();
		});
	</script>

	<style type="text/less">
	@import "../less/vars";
	@import "../less/functions";
	@import "../less/less-rem";
	@import "../less/rem-weui";
	@import "../less/rem-cale";
	@import "../less/global";

	.page_timerange {
		#lunar_cale_panel .hd label{
			display: none;
		}
		.head {
			display: flex;

			p, a {
				display: block;
			}
			p {
				flex: 1;
			}
			a {
				color: #576B95;
				.px2rem(40px, padding-left);
			}
		}
		.field {
			width: 100%;
			display: flex;
			justify-content: space-between;

			p {
				display: block;
				&.to {
					color: #888888;
					.px2rem(30px);
				}
			}
		}
	}
	</style>

</timerange>