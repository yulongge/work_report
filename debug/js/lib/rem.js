!function(e,t){"object"==typeof exports?module.exports=t():"function"==typeof define&&define.amd?define([],t):e["less-rem"]=t()}(this,function(){function e(e){var n=document.querySelector("head meta[name=viewport]");n||(n=document.createElement("meta"),n.setAttribute("name","viewport"),document.getElementsByTagName("head")[0].appendChild(n));var o=window.devicePixelRatio||1,i=parseFloat(1/o).toFixed(2),a=o*screen.width,d=parseFloat(a/t).toFixed(1),r=["width=",a,", initial-scale=",i,", maximum-scale=",i,", user-scalable=0"].join(""),l=document.createElement("style");n.setAttribute("content",r),document.documentElement.firstElementChild.appendChild(l),l.innerHTML="html {font-size:"+d+"px !important}",l=null,console.log("[rem] set root font-size to: %spx",d)}var t=100,n="onorientationchange"in window?"orientationchange":"resize";return function(o){void 0===o&&(o=100),t=o,window.addEventListener(n,e),e()}});