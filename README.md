# Linux系统与网络管理

中国传媒大学 信息安全本科专业（[教学Wiki](https://c4pr1c3.github.io/cuc-wiki/linux.html)） **Linux系统与网络管理**相关课件的源代码仓库。

所有课件内容汇编自互联网，课件成果反馈回互联网。

课件采用markdown语法书写，使用[pandoc](http://pandoc.org/)渲染，幻灯片形式的输出依赖[reveal.js](https://github.com/hakimel/reveal.js.git)（为了保证渲染结果的一致性，我fork了官方的reveal.js库作为本项目的依赖，避免上游reveal.js的更新导致的渲染兼容性问题）。

```bash
# 拉取本项目依赖的子模块 reveal.js
git submodule update --recursive --remote
# 生成幻灯片形式课件和打印版课件
bash render.sh
```

[课件网站在线版](https://c4pr1c3.github.io/LinuxSysAdmin/) 和 [课程视频录像](https://space.bilibili.com/388851616/channel/detail?cid=103824)。


