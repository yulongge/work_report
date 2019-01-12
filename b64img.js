const base64Img = require('base64-img');

const imgs = Array.from(process.argv).slice(2);

console.log(imgs.map(img=>{
	let rst = img + '\n-------------------\n';
	rst += base64Img.base64Sync(img);
	rst += '\n\n';
	return rst;
}).join('\n'));