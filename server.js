var express = require('express');
var http = require('http');
var bodyParser = require('body-parser');
var moment = require("./node_modules/moment/min/moment.min");
var app = new express;
app.set('view engine', 'html');
app.set('views', __dirname + '/');
// app.use(express.static('./debug', {index: 'index.html'}));
app.use(bodyParser.urlencoded({extended: true}));
app.use(bodyParser.json());

app.get('/node_modules/less-rem/dist/rem.less', (req, res)=>{
	res.sendFile(__dirname + '/node_modules/less-rem/dist/rem.less');
});

app.all('/reportapi/*', function(req, res, next) {  
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Credentials", true);
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");  
    res.header("Access-Control-Allow-Methods","PUT,POST,GET,DELETE,OPTIONS");  
    res.header("Content-Type", "application/json;charset=utf-8");  
    next();  
});

//此处模拟了数据库中存储的一组商家数据
const fake_shops = [
	{id: 111, name: "云海肴云南菜", desc: "张大噶 区域经理(华南区)"},
	{id: 222, name: "汉堡王", desc: "张二噶 区域经理(华北区)"},
	{id: 333, name: "江边城外烤鱼"}
];
//此处模拟了暂存的当前选择门店id
let _currentShopId;

//此处模拟了登录态
let _loginAccount = null;

//过滤器：所有请求先验证登录
app.all('/reportapi/*', function(req, res, next) {  

	//!请求参数中如果有code和openid,获取方法也和_from_weapp一样，用来维持登录态

	//判断来源是不是小程序
	const IS_WEAPP = req.method == 'GET'
		? req.query._from_weapp == 1 
		: req.body._from_weapp == 1;

	//判断是非需要验证登录
	const NEED_CHECK = req.method == 'GET'
		? req.path !== '/reportapi' //get请求,除了初始化都校验
		: !/\/login$/.test(req.path); //post请求排除掉登录提交

	console.log(req.method, req.path, IS_WEAPP && NEED_CHECK);

	//如果未登录
    if (IS_WEAPP && NEED_CHECK && !_loginAccount) {
    	res.status(401).end('_need_login_'); //返回401, 小程序就会跳到登录界面
    	return;
    }

    next(); //登录态正常，继续相应请求的逻辑
});

//初始化请求
app.get('/reportapi', (req, res)=> {
	res.send({
		errcode: 0,
		errmsg: 'blablabla...',
		result: {
			//登录界面的约束
			login: {
				'pattern_account': '^[0-9]{3,12}$', //'^\\d{11}$',
				'pattern_password': '^[a-zA-Z0-9]{6,50}$',
				'mismatch_account': '请输入正确的手机号',
				'missing_account': '请输入手机号',
				'mismatch_password': '密码仅支持6至50位的字母和数字',
				'missing_password': '请输入密码',
			},

			//服务热线
			contact: {
		      text: '微生活会员营销服务热线',
		      tel: '400-600-7660'
		    },

		    //版权
		    copyright: '点评微生活 数据中心 V1.0'
		}
	});
})
//登录
app.post('/reportapi/login', (req, res)=>{

	//code为微信小程序特有 https://mp.weixin.qq.com/debug/wxadoc/dev/api/api-login.html#wxloginobject
	const {code, account, password} = req.body;

	const IS_WEAPP = req.body._from_weapp == 1;
	const IS_MULTI_SHOPS = Math.random() > .5;

	// console.log('login', code, account, password);

	if (Math.random() > .5) {

		_loginAccount = account; //记录登录态

		res.send({
			errcode: 0,
			errmsg: '',
			result: {
				openid: 123, //返回openid
				route: IS_WEAPP 
					? IS_MULTI_SHOPS
						? '/pages/shops/shops'
						: '/pages/index/index' 
					: '/'
			}
		});
	} else {
		res.send({
			errcode: 123,
			errmsg: '登录失败',
			result: {
				alert: {
					type: 1,
					msg: '账号密码错误'
				},
				weapp_buttons: [
					{
						label: '重新登录',
						route: '/pages/login/login'
					}
				]
			}
		});
	}
});
//登出
app.post('/reportapi/logout', (req, res)=>{

	const IS_WEAPP = req.body._from_weapp == 1;

	let {account} = req.body;

	if (!account) account = _loginAccount;
	//do sth...
	_loginAccount = null; //清空登录态

	if (IS_WEAPP) {
		res.status(401).end('_need_login_');
    	return;
	}


	res.send({
		errcode: 0,
		errmsg: '',
		result: {
			route: '/'
		}
	});
});
//当前账号信息
app.get('/reportapi/account', (req, res)=> {
	res.send({
		errcode: 0,
		errmsg: '',
		result: {
			account: '18330128501',
			shop: _currentShopId
				? fake_shops.filter(shop=>shop.id==_currentShopId)[0]
				: fake_shops[0],
			isSingleShop: Math.random()>.5,
			allow_receive_message: Math.random()>.5,
		}
	});
});

//是否接受经营状况通知
app.post('/reportapi/receivemessage', (req, res)=> {
	const { receive } = req.body;

	console.log( '是否接受经营状况通知：', receive );

	res.send({
		errcode: 0,
		errmsg: '',
		result: {}
	})
});
//主页
app.get('/reportapi/main', (req, res)=>{

	const IS_WEAPP = req.query._from_weapp == 1;

	let time = req.query.time;
	if (!time || time==='undefined') {
		time = '2016-08-01,2016-08-31';
	}
	
	//默认的门店或上次选择过的门店
	const currentShopId = _currentShopId;
	const shop = fake_shops.filter(shop=>shop.id==currentShopId);

	res.send({
		errcode: 0,
		errmsg: '',
		result: {
			weapp_pagetitle: '二姑包子',

			time: time,
			shop: shop ? shop[0] : null,
			data: [
				{
					title: IS_WEAPP
						? {text: '今日营业额', small: '(元)'}
						: '今日营业额<small>(元)</small>',
					amount: IS_WEAPP
						? {text: '186,108', small: '.00'}
						: '186,108<small>.00</small>',
					desc: IS_WEAPP
						? {text: '', small: '统计时间截至15:32'}
						: '<small>统计时间截至15:32</small>',
					group1: [
						{
							key: IS_WEAPP
								? {text: '消费均价', small: '(元)'}
								: '消费均价<small>(元)</small>',
							value: IS_WEAPP
								? {text: '28,060', small: '.00'}
								: '28,060<small>.00</small>'
						},
						{
							key: IS_WEAPP
								? {text: '消费笔数', small: '(笔)'}
								: '消费笔数<small>(笔)</small>',
							value: IS_WEAPP
								? {text: '6,126', small: ''}
								: '6,126'
						}
					],
					group2: [
						{
							key: IS_WEAPP
								? {text: '储值支付', small: '(元)'}
								: '储值支付<small>(元)</small>',
							value: IS_WEAPP
								? {text: '166,182', small: '.00'}
								: '166,182<small>.00</small>',
							icon: 'http://localhost:3201/img/chuzhizhifu.png'
						},
						{
							key: IS_WEAPP
								? {text: '积分抵扣', small: '(元)'}
								: '积分抵扣<small>(元)</small>',
							value: IS_WEAPP
								? {text: '16,182', small: '.00'}
								: '16,182<small>.00</small>',
							icon: 'http://localhost:3201/img/jifendikou.png'
						},
						{
							key: IS_WEAPP
								? {text: '优惠券抵扣', small: '(元)'}
								: '优惠券抵扣<small>(元)</small>',
							value: IS_WEAPP
								? {text: '16,182', small: '.00'}
								: '16,182<small>.00</small>',
							icon: 'http://localhost:3201/img/youhuiquandikou.png'
						},
						{
							key: IS_WEAPP
								? {text: '实收金额', small: '(元)'}
								: '实收金额<small>(元)</small>',
							value: IS_WEAPP
								? {text: '162,182', small: '.00'}
								: '162,182<small>.00</small>',
							icon: 'http://localhost:3201/img/shishoujine.png'
						},
					]
				},
				{
					title: IS_WEAPP
						? {text: '充值总额', small: '(元)'}
						: '充值总额<small>(元)</small>',
					amount: IS_WEAPP
						? {text: '186,108', small: '.00'}
						: '186,108<small>.00</small>',
					desc: IS_WEAPP
						? {pre: '共', text: '999', small: '笔'}
						: '<small>共</small>999<small>笔</small>',
					group1: [
						{
							key: IS_WEAPP
								? {text: '实收金额', small: '(元)'}
								: '实收金额<small>(元)</small>',
							value: IS_WEAPP
								? {text: '28,060', small: '.00'}
								: '28,060<small>.00</small>'
						},
						{
							key: IS_WEAPP
								? {text: '奖励金额', small: '(元)'}
								: '奖励金额<small>(元)</small>',
							value: IS_WEAPP
								? {text: '6,126', small: '.00'}
								: '6,126<small>.00</small>'
						}
					],
					group2: [
						{
							key: IS_WEAPP
								? {text: '储值余额', small: '(元)'}
								: '储值余额<small>(元)</small>',
							value: IS_WEAPP
								? {text: '6,126,812', small: '.00'}
								: '6,126,812<small>.00</small>',
							icon: 'http://localhost:3201/img/chuzhiyue.png'
						}
					]
				},
				{
					title: IS_WEAPP
						? {text: '新增会员', small: '(人)'}
						: '新增会员<small>(人)</small>',
					amount: IS_WEAPP
						? {text: '186,108', small: ''}
						: '186,108',
					desc: null,
					group1: [
						{
							key: IS_WEAPP
								? {text: '新增消费会员', small: '(人)'}
								: '新增消费会员<small>(人)</small>',
							value: IS_WEAPP
								? {text: '28,060', small: ''}
								: '28,060'
						},
						{
							key: IS_WEAPP
								? {text: '新增储值会员', small: '(人)'}
								: '新增储值会员<small>(人)</small>',
							value: IS_WEAPP
								? {text: '6,126', small: ''}
								: '6,126'
						}
					],
					group2: [
						{
							key: IS_WEAPP
								? {text: '会员存量', small: '(人)'}
								: '会员存量<small>(人)</small>',
							value: IS_WEAPP
								? {text: '6,126,812', small: ''}
								: '6,126,812',
							icon: 'http://localhost:3201/img/huiyuancunliang.png'
						}
					]
				}
			]
		}
	});
});
//排行榜
app.get('/reportapi/ranking', (req, res)=>{

	const IS_WEAPP = req.query._from_weapp == 1;

	let key = req.query.key;
	if (!key || key==='undefined') {
		key = 'yye';
	}

	let time = req.query.time;
	if (!time || time==='undefined') {
		time = '2016-08-01,2016-08-31';
	}

	res.send({
		errcode: 0,
		errmsg: '',
		result: {
			weapp_pagetitle: '老姨锅贴',

			time: time,
			key: key, //对应于tabs
			tabs: [
				{label: '营业额', key: 'yye'},
				{label: '充值总额', key: 'czze'},
				{label: '新增会员', key: 'xzhy'}
			],
			summary: {
				label: IS_WEAPP
					? {text: '啥啥啥', small: '(元)'}
					: '啥啥啥<small>(元)</small>',
				value: IS_WEAPP
					? {text: '6,126,812', small: (key==='xzhy' ? '' : '.00')}
					: '6,126,812' + (key==='xzhy' ? '' : '<small>.00</small>'),
				time: '统计时间截至09:32'
			},
			table: {
				cols: ['门店', '营业额', '占比'],
				items: [
					{rank:1, data:['上地店'+Math.random(), '168,032.00', '10.02%']},
					{rank:10, data:['上10店', '168,032.00', '10.02%']},
					{rank:2, data:['上2地店', '132.00', '10.02%']},
					{rank:3, data:['上3地店', '168,032.00', '10.02%']},
					{rank:4, data:['上4地店', '168,032.00', '10.02%']},
					{rank:5, data:['中关村南路南路南路南路', '168,032.00', '10.02%']},
					{rank:6, data:['上5店', '168,032.00', '1.02%']},
					{rank:7, data:['上地店', '168,032.00', '10.02%']},
					{rank:8, data:['上地店', '168,032.00', '10.02%']},
					{rank:9, data:['上地店', '168,032.00', '10.02%']},
					{rank:11, data:['上地店', '168,032.00', '10.02%']},
					{rank:12, data:['上地店', '168,032.00', '10.02%']},
					{rank:13, data:['上地店', '168,032.00', '10.02%']},
					{rank:14, data:['上地店', '168,032.00', '10.02%']},
					{rank:15, data:['15地店', '168,032.00', '10.02%']},
					{rank:16, data:['上地店', '168,032.00', '10.02%']},
					{rank:17, data:['上地店', '168,032.00', '10.02%']},
					{rank:18, data:['上地店', '168,032.00', '10.02%']},
					{rank:19, data:['上地店', '168,032.00', '10.02%']}
				]
			}
		}
	});
});

//切换绑定的多个商家
app.get('/reportapi/shops', (req, res)=>{

	let currentShopId = req.query.currentShopId;
	res.send({
		errcode: 0,
		errmsg: '',
		result: {
			tel: '133****5111',
			shops: fake_shops.map(shop=>{
				shop.isCurr = shop.id == currentShopId;
				return shop;
			})
		}
	});
});
app.post('/reportapi/shops', (req, res)=>{

	//请求携带的参数
	let {currentShopId, fromRoute} = req.body;
	if (!fromRoute || fromRoute === 'undefined') fromRoute = null;

	//在这里记录选择的id
	console.log('POST /reportapi/shops', currentShopId);
	_currentShopId = currentShopId;

	res.send({
		errcode: 0,
		errmsg: '',
		result: {
			//然后跳转回指定的来源页面或主页
			route: fromRoute || '/'
		}
	});
});

var server = http.createServer(app);

module.exports = {
	runserver(port, dir) {
		app.use(express.static(dir, {index: 'index.html'}));
		app.set('port', port);
		let host = '127.0.0.1';
	    server.listen(port, host);
	    server.on('error', (e) => {
			if (e.code === 'EADDRNOTAVAIL') {
				host = '127.0.0.1';
				server.listen(port, host);
			}
		}).on('listening', e=>console.log(`server run at http://${host}:${port} (${dir})`));
	}
};
