<main-box>
	
	<div class="ainn">
		<div class="main">
			<h2><raw content={title} /></h2>
			<h1><raw content={amount} /></h1>
			<h3><raw content={desc} /></h3>
			<ul>
				<li each={group1}>
					<label><raw content={key} /></label>
					<p><raw content={value} /></p>
				</li>
			</ul>
		</div>
		<ul class="details">
			<li each={group2}>
				<figure style="background-image:url('{icon}')"></figure>
				<label><raw content={key} /></label>
				<p><raw content={value} /></p>
			</li>
		</ul>
	</div>

	<script>
	this.update(opts.data);
	</script>
	
	<style type="text/less">
	@import "../less/vars";
	@import "../less/functions";
	@import "../less/less-rem";
	@import "../less/rem-weui";
	@import "../less/global";
	@import "../less/mods";

	#main section article {

		&:nth-of-type(3n+1) .ainn .main {
			background-color: #FA5D3F;
		}
		&:nth-of-type(3n+2) .ainn .main {
			background-color: #FCBB30;
		}
		&:nth-of-type(3n+3) .ainn .main {
			background-color: #21CB60;
		}

		.ainn {
			.px2rem(20px, margin-bottom);

			.main {
				.px2rem(475px, max-height);
				color: #fff;
				background: url('@{img}wave.png') no-repeat bottom left;
				.px2rem_2(720px, 103px, background-size);
				overflow:hidden;

				h1,h2,h3 {
					text-align: center;
					display: block;
					font-weight: normal;
				}
				h2 {
					color: rgba(255,255,255,.82);
					.alignTextWithSmall();
					.px2rem(60px, line-height);
					.px2rem(28px);
					.px2rem(40px, margin-top);
					small {
						.px2rem(24px);
					}
				}
				h1 {
					.Neue();
					.px2rem(100px, line-height);
					.px2rem(84px);
					small {
						.px2rem(46px);
					}
				}
				h3 {
					color: rgba(255,255,255,.72);
					.px2rem(32px, line-height);
					.px2rem(32px);
					small {
						.px2rem(24px);
					}
				}
				ul {
					.px2rem(200px, min-height);
					display: flex;
					align-items: center;

					li {
						width: 50%;
						flex: 1;
						box-sizing: border-box;
						.px2rem(80px, padding-left);

						label {
							color: rgba(255,255,255,.82);
							display: block;
							.px2rem(58px, line-height);
							.px2rem(28px);
							small {
								.px2rem(24px);
							}
						}
						p {
							.Neue();
							.px2rem(70px, line-height);
							.px2rem(42px);
							small {
								.px2rem(24px);
							}
						}
					}
				}
			} //end of .main
			.details:extend(#main section article .ainn .main ul all) {
				background: #fff;
				flex-wrap: wrap;
				width: 100%;
				min-height: 0;
				
				li {
					position: relative;
					border-bottom: 1px solid #DCDCDC;
					.px2rem(1px, border-bottom-width);
					.px2rem(165px, height);
					flex: initial;
				    .px2rem(100px, padding-left);

					&:nth-of-type(2n+1)::after {
						content: ' ';
						display: inline-block;
						background: rgba(219,225,232,.66);
						.px2rem(1px, width);
						.px2rem(96px, height);
						position: absolute;
						right: 0;
						top: 50%;
						transform: translateY( unit(-48px/@rem-base, rem) );
					}
					&:only-of-type::after {
						display: none;
					}

					&:only-of-type {
						flex: 1;
						display: flex;
						align-items: center;
						.px2rem(110px, height);
						padding-left: 0;
						figure {
							position: static;
							.px2rem_4(0, 15px, 0, 30px, margin);
						}
						label {
							margin-top: 0;
							line-height: inherit;
							flex: 1;
						}
						p {
							line-height: inherit;
							.px2rem(30px, margin-right);
							.px2rem(32px);
						}
					}
					
					figure {
						.px2rem(56px, width);
						.px2rem(56px, height);
						background-size: contain;
						background-repeat: no-repeat;
						background-position: 0 0;
						position: absolute;
						.px2rem(53px, top);
						.px2rem(24px, left);
					}
					label {
						.px2rem(30px, margin-top);
						.px2rem(46px, line-height);
						.px2rem(26px);
						color: #B2B2B2;
						small {
							.px2rem(22px);
						}
					}
					p {
						.px2rem(54px, line-height);
						.px2rem(30px);
						small {
							.px2rem(22px);
						}
					}
				}
			} //end of .details
		}
	}
	</style>
</main-box>