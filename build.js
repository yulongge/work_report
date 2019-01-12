const
    PORT = 3200
    ,PORT2 = 3201
    ,{argv} = require('yargs')
    ,env = argv.mode
    ,fs = require('fs-extra')
    ,path = require('path')
    ,pug = require('pug')
    ,riot = require('riot')
    ,less = require('less')
    ,uglifyjs = require("uglify-js")
    ,uglifycss = require('uglifycss')
    ,autoprefixer = require('autoprefixer')
    ,postcss = require('postcss')
    ,watch = require('watch')
    ,rmdirSync = require('rmdir-sync')
    ,{runserver} = require('./server')
    ,PUB_PATH = env === 'build'
        ? './public/'
        : './debug/'
    ,INDEX_JS = PUB_PATH + 'js/index.js'
    ,INDEX_MIN_JS = PUB_PATH + 'js/index.min.js'
    ,pub_to_root = path=> path.replace(PUB_PATH, '/')
    ,JSLIB_PATH = PUB_PATH + 'js/lib/'
    ,CSSLIB_PATH = PUB_PATH + 'css/lib/'
    ,IMG_PATH = PUB_PATH + 'img/'
    ,lib_prefix = lib=>(lib.path=`./node_modules/${lib.path}`,lib)
    ,lib_filter = lib=>{
        if (env === 'build') return !lib.onlyDev;
        if (env === 'init') return !lib.onlyPub;
        return true;
    }
    ,_cssLibs = [
        {path:"jquery-weui/dist/lib/", name:"weui.min.css", isMin:true}
        ,{path:"jquery-weui/dist/css/", name:"jquery-weui.css", isMin:false}
        //,{path:"chartist/dist/", name:"chartist.min.css", isMin:true}
    ].filter(lib_filter).map(lib_prefix)
    ,_jsLibs = [
        {path:"zepto/dist/", name:"zepto.min.js", isMin:true}
        ,{path:"zepto/src/", name:"callbacks.js", isMin:false, rename:"zepto.callbacks.js"}
        ,{path:"zepto/src/", name:"deferred.js", isMin:false, rename:"zepto.deferred.js"}
        ,{path:"mobile-utils/lib/", name:"mobile-utils.min.js", isMin:true}
        ,{path:"riot/", name:"riot.min.js", isMin:true, onlyPub:true}
        ,{path:"riot/", name:"riot+compiler.js", isMin:false, onlyDev:true}
        ,{path:"less/dist/", name:"less.min.js", isMin:true, onlyDev:true}
        ,{path:"less-rem/dist/", name:"rem.js", isMin:false}
        ,{path:"lunar-cale/lib/", name:"lunar-cale.min.js", isMin:true}
        ,{path:"moment/min/", name:"moment.min.js", isMin:true}
        ,{path:"jquery-weui/dist/js/", name:"jquery-weui.js", isMin:false}
        ,{path:"vconsole/dist/", name:"vconsole.min.js", isMin:true, onlyDev:true}
    ].filter(lib_filter).map(lib_prefix)

    ,copy_libs = (libs, dest) => {
        fs.ensureDirSync(dest);
        fs.emptyDirSync(dest);
        libs.forEach(lib=> {
            var
                from = lib.path + lib.name
                ,to = dest + (lib.rename || lib.name)
            ;
            console.log(`copy ${lib.name} from ${from} to ${dest}`);
            try {
                if (lib.isMin || lib.onlyDev) {
                    fs.copySync(from, to, {clobber: true});
                } else if (/\.js$/.test(lib.name)) {
                    fs.writeFileSync(to, uglifyjs.minify(from).code);
                } else if (/\.css$/.test(lib.name)) {
                    fs.writeFileSync(to, uglifycss.processFiles([from]));
                }
            } catch(ex) {
                console.error(ex);
            }
        });
    }
    ,copy_imgs = (file=null)=> {
        if (file)
            fs.copySync(file, file.replace(/^src/, 'debug'), {clobber: true});
        else
            fs.copySync('src/img', IMG_PATH, {clobber: true});
        console.log('imgs copyed!');
    }
    ,make_index = ()=> { //make entry html
        let index_html = pug.renderFile('src/index.pug', {
            pretty: true
            ,cssLibs: _cssLibs.map(lib=> CSSLIB_PATH+(lib.rename||lib.name)).map(pub_to_root)
            ,jsLibs: _jsLibs.map(lib=> JSLIB_PATH+(lib.rename||lib.name)).map(pub_to_root)
            ,indexjs: '/' + (env === 'build' ? INDEX_MIN_JS : INDEX_JS).replace(PUB_PATH, '')
        });
        fs.writeFileSync(PUB_PATH + 'index.html', index_html);
        console.log('build index.html ok!');
    }
    ,concat_indexjs = ()=> {
        let
            parts = 'config,utils,i18n,components,starter'.split(',')
            ,file = fs.openSync(INDEX_JS, 'w')
        ;
        fs.appendFileSync(file, `var _develop_env='${env}';\n\n`);
        parts.forEach(part=>{
            let content = fs.readFileSync(`src/js/${part}.js`, 'utf8');
            fs.appendFileSync(file, content);
            fs.appendFileSync(file, "\n\n");
        });
        fs.closeSync(file);
        console.log('build '+INDEX_JS+' ok!');
    }
    ,extract_css_from_tag_str = str=>{
        let
            div = String.raw`\,\s+`
            ,start_and_tagname = String.raw`^riot\.tag2\(\'[^\']+\'`
            ,template_or_style = String.raw`\'((\\\'|[^\'])+)\'`
            ,css_re_str = [
                start_and_tagname
                ,template_or_style
                ,template_or_style
            ].join(div).replace(/\\/g, "\\")
            ,css_re = new RegExp(css_re_str, 'im') // /^riot\.tag2\(\'[^\']+\'\,\s+\'(\\\'|[^\'])+\'\,\s+\'((\\\'|[^\'])+)\'/
        ;
        let cssmatch = str.match(css_re);
        if (cssmatch && cssmatch.length>3){
            let css = cssmatch[3];
            return css;
        }
        return null;
    }
    ,compile_tags = ()=> {
        return new Promise((resolve, reject) => {
            let
                file = fs.openSync(INDEX_JS, 'a')
                ,append = cont=>{
                    fs.appendFileSync(file, cont+"\n\n");
                    if (++flag === files.length) {
                        fs.closeSync(file);
                        //console.log('closed');
                    }
                }
                ,dir = 'src/tags/'
                ,flag = 0
                ,files = fs.readdirSync(dir)
            ;

            files.forEach((item,idx,arr)=>{
                let fpath = dir + item;
                if (/\.tag$/.test(fpath)) {
                    let
                        tagCont = fs.readFileSync(fpath, 'utf8')
                        ,tagJS
                        ,css
                    ;
                    tagCont = tagCont.replace(/\@import\s+\"\.\.\/less\//g, '@import "src/less/');
                    tagJS = riot.compile(tagCont, {css: "myless"});
                    css = extract_css_from_tag_str(tagJS);
                    if (css) {
                        postcss([ autoprefixer ]).process(css).then(result=>{
                            tagJS = tagJS.replace(css, result.css);
                            console.log('[autoprefixer] success:', fpath);
                            append(tagJS);
                            if (idx === arr.length-1) resolve();
                        }).catch(err=>{
                            console.warn('[autoprefixer]', css, fpath);
                            console.warn(err);
                            append(tagJS);
                            reject(err);
                        });
                    } else {
                        append(tagJS);
                        if (idx === arr.length-1) resolve();
                    }
                }
            });
        });
    }
    ,copy_tags = (file=null)=> {
        fs.copySync('src/less', 'debug/less', {clobber: true});
        if (file)
            fs.copySync(file, file.replace(/^src/, 'debug'), {clobber: true});
        else
            fs.copySync('src/tags', 'debug/tags', {clobber: true});
        fix_debug_tags_less();
        console.log('tags copyed!');
    }
    ,fix_debug_tags_less = ()=> { //"@import" cannot run in browser less
        let dir = 'debug/tags/';
        let tags = fs.readdirSync(dir);
        tags.forEach(path=>{
            let
                content = fs.readFileSync(dir + path, 'utf8')
                ,re = ()=>/\@import\s+\"\.{2}\/(less.*)\"\;/g
            ;
            (content.match(re()) || []).forEach(m=>{
                let
                    less_path = re().exec(m)[1]
                    ,less_content = fs.readFileSync(`src/${less_path}.less`)
                    ,import_re = new RegExp(`\\@import\\s+\\"\\.{2}\\/${less_path}\\"\\;`, 'g')
                ;
                content = content.replace(import_re, less_content);
                //console.log(`replace "${less_path}" of ${path}`);
            });
            fs.writeFileSync(dir + path, content);
        });
    }
;

if (argv.watch == 1) {
    let
        file_type = f=>/\.([^\.]*)$/.exec(f)[1]
        ,handle_change = f=>{
            let type = file_type(f).toLowerCase();
            switch (type) {
                case 'tag':
                case 'less':
                    copy_tags(type==='tag'?f:null);
                    break;
                    break;
                case 'jpg':
                case 'gif':
                case 'png':
                case 'jpeg':
                    copy_imgs(f);
                    break;
                case 'js':
                    concat_indexjs();
                case 'pug':
                    make_index();
                    break;
                default:
                    break;
            }
            console.log('watching...');
        }
    ;
    watch.createMonitor('src/', monitor=>{
        monitor.on("created", (f, stat)=> {
            console.log('Handle new file:', f);
            handle_change(f);
        })
        monitor.on("changed", (f, curr, prev)=> {
            console.log((new Date().getTime()), ' - Handle file changes:', f);
            handle_change(f);
        })
        monitor.on("removed", (f, stat)=> {
            console.log('Handle removed file:', f);
            handle_change(f);
        })
    });
    console.log('watching...');
    
    runserver(PORT, './debug');
} else if (env === 'see') {
    runserver(PORT2, './public');
} else {
    rmdirSync(PUB_PATH);
    fs.ensureDirSync(PUB_PATH);
    copy_libs(_jsLibs, JSLIB_PATH);
    copy_libs(_cssLibs, CSSLIB_PATH);
    copy_imgs();
    concat_indexjs();
    if (env === 'init') {
        copy_tags();
    } else if (env === 'build') {
        compile_tags().then(()=>{
            fs.writeFileSync(INDEX_MIN_JS, uglifyjs.minify(INDEX_JS, {
                // comments: false,
                // mangle: false,
                // compress: false,
                beautify: true
            }).code);
            fs.unlinkSync(INDEX_JS);
            console.log(INDEX_JS, '==>', INDEX_MIN_JS, ' ok!');
        }).catch(err=>console.warn('Error in compile_tags: ', err));
    }
    make_index();
}