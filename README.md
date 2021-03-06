#商家经营报告项目_task-view-2667#
-----------

##安装必须依赖
- 安装 [nodejs](https://nodejs.org/en/) 环境后，运行 `npm install`
- 前端开发时需要多安装一步 `npm i -g node-dev` (必要时需sudo)

##脚本命令
> 以 ` npm run xxx ` 形式运行

- `reset`: 构建调试目录(src->debug)
- `build`: 编译到发布目录(src->public)
- `see`: 查看最终效果，在public目录运行服务器
- `watch`: 开发调试，在debug目录运行服务器，并动态编译src
- `doc`: 生成工具api文档并更新 README.md

##PHP调试：
- 数据接口参考 `server.js`
- 前端路由参考 `src/js/config.js`，浏览方式类似于 `http://127.0.0.1:3201/#ranking&time=2016-11-03,2016-11-03`
- 在 `index.html` 中自定义 `ajax_prefix` 参数等 
- 返回值`result`节点中`isInPageAjax=>true`时，页面不会自动调到顶部
- 返回值`result`节点中有`alert`时，自动弹出提示，参考 `server.js`
- 返回值`result`节点中有`route`时，自动按前端路由跳转页面，参考 `server.js`

##前端开发
- 采用 [RiotJS](http://riotjs.com/) 、[pug](https://pugjs.org/)、[jquery-weui](http://old.jqweui.com/components) 等开发
- 不能直接编辑 README.md, 而是编写 README.hbs 并运行doc脚本命令
- 前端路由定义在 `src/js/config.js`
- 语言包定义在 `src/js/i18n.js`
- 可以直接用类html标签加载的组件定义在 `src/js/components.js`
- 一般的业务组件定义在 `src/tags` 下
- 每个组件的`opts`属性中都可以获取以下参数： `id`(组件id名)、`args`(路由参数)、`params`(query参数)、`utils`(app.utils工具方法)、`i18n`(语言包)
- 以下说明中的“页面组件”表示由路由渲染的整页界面组件，而非局部组件
- 页面组件加载后，根据其id，html和body元素自动添加样式`root_xxx`和`page_xxx`
- 在页面组件中监听析构函数 `this.on('destruct', func)`，可以在该页被关闭前作一些清理工作
- 可以通过`app.utils`直接采用 [mobile-utils库](https://www.npmjs.com/package/mobile-utils) 中的全部方法
- `app.utils`中的其他工具API在文档最下方

---------------
<a name="app"></a>

## app : <code>object</code>
**Kind**: global namespace  

* [app](#app) : <code>object</code>
    * [.utils](#app.utils)
        * [.do_get](#app.utils.do_get) ⇒ <code>Promise</code>
        * [.do_post](#app.utils.do_post) ⇒ <code>Promise</code>
        * [.load_tag(tagPath, opts, [selector])](#app.utils.load_tag) ⇒ <code>void</code>
        * [.status(code)](#app.utils.status) ⇒ <code>String</code>
        * [.alert([options])](#app.utils.alert) ⇒ <code>void</code>

<a name="app.utils"></a>

### app.utils
**Kind**: static property of <code>[app](#app)</code>  

* [.utils](#app.utils)
    * [.do_get](#app.utils.do_get) ⇒ <code>Promise</code>
    * [.do_post](#app.utils.do_post) ⇒ <code>Promise</code>
    * [.load_tag(tagPath, opts, [selector])](#app.utils.load_tag) ⇒ <code>void</code>
    * [.status(code)](#app.utils.status) ⇒ <code>String</code>
    * [.alert([options])](#app.utils.alert) ⇒ <code>void</code>

<a name="app.utils.do_get"></a>

#### utils.do_get ⇒ <code>Promise</code>
自带默认处理逻辑的ajax GET方法

**Kind**: static property of <code>[utils](#app.utils)</code>  

| Param | Type | Default | Description |
| --- | --- | --- | --- |
| url | <code>String</code> |  | 不包含prefix的请求路径 |
| [params] | <code>Object</code> | <code></code> | 请求参数 |
| [errCallback] | <code>function</code> | <code></code> | 自定义的错误处理函数 |

<a name="app.utils.do_post"></a>

#### utils.do_post ⇒ <code>Promise</code>
自带默认处理逻辑的ajax POST方法

**Kind**: static property of <code>[utils](#app.utils)</code>  

| Param | Type | Default | Description |
| --- | --- | --- | --- |
| url | <code>String</code> |  | 不包含prefix的请求路径 |
| [params] | <code>Object</code> | <code></code> | 请求参数 |
| [errCallback] | <code>function</code> | <code></code> | 自定义的错误处理函数 |

<a name="app.utils.load_tag"></a>

#### utils.load_tag(tagPath, opts, [selector]) ⇒ <code>void</code>
动态加载一个tag

**Kind**: static method of <code>[utils](#app.utils)</code>  

| Param | Type | Default | Description |
| --- | --- | --- | --- |
| tagPath | <code>String</code> |  | tag名（不包含路径和扩展名） |
| opts | <code>Object</code> |  | 参数 |
| [selector] | <code>String</code> | <code></code> | css选择器 |

<a name="app.utils.status"></a>

#### utils.status(code) ⇒ <code>String</code>
映射操作结果的状态字符串，用于弹窗和消息页等

**Kind**: static method of <code>[utils](#app.utils)</code>  

| Param | Type | Description |
| --- | --- | --- |
| code | <code>Number</code> | 0 'success' | 1 'warn' |

<a name="app.utils.alert"></a>

#### utils.alert([options]) ⇒ <code>void</code>
弹出提示

**Kind**: static method of <code>[utils](#app.utils)</code>  

| Param | Type | Default |
| --- | --- | --- |
| [options] | <code>Object</code> | <code>{title, content, buttonText, onclick}</code> | 

