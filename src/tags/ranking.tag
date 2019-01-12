<ranking id={opts.id}>
	
	<header></header>
	<menu></menu>
	<section hide={!summary}>
		<div class="summary">
			<div class="mod_flex">
				<label><raw content={summary.label} auto_update={true}/></label>
				<p name="main_vlu"><raw content={summary.value} auto_update={true} /></p>
			</div>
			<time>{ summary.time }</time>
		</div>
		<table>
			<thead>
				<tr>
					<th>{ opts.i18n.ranking.rank }</th>
					<th each={ name in table.cols }>{ name }</th>
				</tr>
			</thead>
			<tbody>
				<tr each={ sorted_table }>
					<td>
						<em if={ rank < 4 } class={ 'r'+rank }>{rank}</em>
						<span if={ rank >= 4 }>{rank}</span>
					</td>
					<td each={ v in data }>{ v }</td>
				</tr>
			</tbody>
		</table>
	</section>
	<footer></footer>

	<script>
		var
			args = opts.args
			,params = opts.params
			,utils = opts.utils
			,i18n = opts.i18n
			,_this = this
			,tabsOb = riot.observable()
			,get_path = function(time, key, isRequest) {
				var r = 'ranking';
				r += isRequest ? '?' : '&';
				r+= 'time='+time||'';
				r+= '&key='+key||'';
				return r;
			}
		;

		this.on('update', function(data) { //需求要求数字滚动
			if (!data) return;
			var
				vlu = data.summary.value
				,dec = /\<small\>\.\d+\<\/small\>/.exec(vlu)
				,flag = 0
			;
			if (dec) {
				dec = dec[0];
				vlu = vlu.replace(dec, '');
			} else {
				dec = '';
			}
			vlu = vlu.replace(/\,/g, '');
			vlu = parseInt(vlu);

			var share = vlu.toString().length - 1;
			if (share>2) share = 2;
			share = Math.pow(10, share);
			var base = parseInt(vlu / share);
			var itv_time = (share > 10 ? 6.2 * 5 : 62 * 2);

			this._numScrollItv = setInterval(function() {
				if (flag < vlu) {
					var step = Math.min(vlu - flag, base);
					_this.main_vlu.innerHTML = utils.format.knot_num(flag+=step) + dec;
				} else {
					clearInterval(_this._numScrollItv);
				}
			}, itv_time);
		});
		this.on('destruct', function() {
			clearInterval(this._numScrollItv);
		});

		utils.do_get( get_path(params.time, params.key, true) ).then(
			function(rst) {

				var sorted_table = rst.table.items.sort( function(a,b){return a.rank-b.rank;} );
				_this.update( $.extend(rst, {sorted_table: sorted_table}) );

				//头部
				utils.load_tag('main-headtime', {
					from: 'ranking',
					time: rst.time
				}, 'header');
				//标签
				utils.load_tag('rank-tabs', {
					tabs: rst.tabs,
					current: rst.key,
					ob: tabsOb
				}, 'menu');
				tabsOb.on('toggle', function(key) {
					riot.route( get_path(params.time, key) );
				});
				//尾部
				utils.load_tag('main-foottabs', {
					current: 'ranking',
					time: params.time
				}, 'footer');
			}
		);
		
	</script>

	<style type="text/less">
	@import "../less/vars";
	@import "../less/functions";
	@import "../less/less-rem";
	@import "../less/rem-weui";
	@import "../less/global";
	
	.root_ranking,
	.page_ranking {
		height: 100%;
		background-color: #F3F1EE;
	}
	#ranking {
		height: 100%;
		display: flex;
		flex-direction: column;

		section {
			flex: 1;
			overflow-x: hidden;
			overflow-y: auto;
			-webkit-overflow-scrolling:touch;

			.summary {
				.px2rem(180px, height);
				.px2rem_2(0, 30px, padding);
				background-image: url('@{img}wave2.png');
				background-repeat: no-repeat;
				background-position: bottom left;
				.px2rem_2(720px, 110px, background-size);
				overflow: hidden;

				>div {
					justify-content: space-between;
					align-items: center;
					.px2rem(90px, height);

					label {
						color: #888888;
						.px2rem(28px);
						small {
							.px2rem(24px);
						}
					}
					p {
						.Neue();
						color: #09BB07;
						.px2rem(60px);
						small {
							.px2rem(36px);
						}
					}
				}
				time {
					.px2rem(55px, line-height);
					color: rgba(53,53,53, .5);
					.px2rem(24px);
					float: right;
				}
			}
			table {
				background-color: #fff;
				.px2rem(26px);
				border-bottom: solid #e4e4e4;
				.px2rem(1px, border-bottom-width);

				&, td {
					border: none;
					border-top: solid #e4e4e4;
					.px2rem(1px, border-top-width);
				}
				th, td {
					.px2rem(20px, padding-left);
					box-sizing: border-box;
					text-align: left;
					&:first-of-type {
						padding: 0;
						.px2rem(130px, width);
						text-align: center;
					}
				}
				th {
					color: #B2B2B2;
					.px2rem(86px, line-height);
				}
				td {
					.px2rem(110px, line-height);
					.px2rem(165px, max-width);
					.ellipsis;
					em {
						.px2rem(40px, width);
						.px2rem(40px, height);
						.px2rem(40px, line-height);
						border-style: solid;
						border-radius: 25%;
						font-style: normal;
						display: inline-block;
						margin: 0 auto;

						&.r1 {
							background-color: rgba(0, 189, 0, .1);
							border-color: rgba(0, 189, 0, .66);
							color: rgba(0, 189, 0, .66);
						}
						&.r2 {
							background-color: rgba(0, 189, 0, .03);
							border-color: rgba(0, 189, 0, .6);
							color: rgba(0, 189, 0, .6);
						}
						&.r3 {
							background-color: rgba(0, 189, 0, 0);
							border-color: rgba(0, 189, 0, .3);
							color: rgba(0, 189, 0, .5);
						}
					}
				}
			}
		}
	}
	</style>

</ranking>