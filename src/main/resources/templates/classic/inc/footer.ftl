<footer class="footer">
    <div class="container">
        <div class="footer-row">
            <nav class="footer-nav">
                <a class="footer-nav-item footer-nav-logo" href="${base}/">
                    <img src="<@resource src=options['site_logo']/>" alt="site_logo"/>
                </a>
                <span class="footer-nav-item">${options['site_copyright']}</span>
                <span class="footer-nav-item">${options['site_icp']}</span>
            </nav>
            <div class="gh-foot-min-back hidden-xs hidden-sm">
                <span class="footer-nav-item">Powered by <a>sharing</a></span>
            </div>
            <br/>
        </div>
        <#--<div class="friendLinks" style="text-align: center;margin: 0 auto">
            <table style="table-layout:fixed;text-align: center;">
                <tr>
                    <td>友情链接:</td>
                    <td>&nbsp;<i class="fa fa-rocket"></i><a href="exam.wangcl.xyz" title="EXAM在线测试">EXAM在线测试</a></td>
                    <td>&nbsp;<i class="fa fa-rocket"></i><a href="video.wangcl.xyz" title="Video视点">Video视点</a></td>
                    <td>&nbsp;<i class="fa fa-rocket"></i><a href="wangcl.xyz" title="Mr.Wang blog">Mr.Wang blog</a>
                    </td>
                </tr>
        </div>-->
    </div>

</footer>
<p id="back-top" style="display:none"><a href="#top"><span></span></a></p>
<#-- 返回顶部 -->
<a href="#" class="site-scroll-top">
    <i class="fa fa-rocket"></i>
</a>

<script type="text/javascript">
    $(function () {
        // hide #back-top first
        $("#back-top").hide();
        // fade in #back-top
        $(window).scroll(function () {
            if ($(this).scrollTop() > 500) {
                $('#back-top').fadeIn();
            } else {
                $('#back-top').fadeOut();
            }
        });
        // scroll body to 0px on click
        $('#back-top a').click(function () {
            $('body,html').animate({
                scrollTop: 0
            }, 800);
            return false;
        });
    });
</script>


<#--进度条pace.js初始化-->
<script type="text/javascript">
    seajs.use('main', function (main) {
        main.init();
    });
</script>

<#--&lt;#&ndash; 鼠标跟随动态线条 &ndash;&gt;
<script type="text/javascript" src="https://blog-static.cnblogs.com/files/yadongliang/canvas-nest.min.js"></script>
<canvas height="926" width="1920" style="position: fixed; top: 0px; left: 0px; z-index: -1; opacity: 0.5;" id="c_n1"></canvas>-->
<#--鼠标点击特效-->
<script>
    /* mouse click */
    var a_idx = 0;
    jQuery(document).ready(function ($) {
        $("body").click(function (e) {
            var a = new Array("富强", "民主", "文明", "和谐", "自由", "平等", "公正", "法治", "爱国", "敬业", "诚信", "友善", "☆", "★", "♥");
            var $i = $("<span></tagObj>").text(a[a_idx]);
            a_idx = (a_idx + 1) % a.length;
            var x = e.pageX,
                y = e.pageY;
            $i.css({
                "z-index": 999999999999999999999999999999999999999999999999999999999999999999999,
                "top": y - 20,
                "left": x,
                "position": "absolute",
                "font-weight": "bold",
                "color": "#ff6651"
            });
            $("body").append($i);
            $i.animate({
                    "top": y - 180,
                    "opacity": 0
                },
                1500,
                function () {
                    $i.remove();
                });
        });
    });
</script>
<#--时钟控制-->
<script>
    var clock = new Vue({
        el: '#clock',
        data: {
            time: '',
            date: ''
        }
    });
    var week = ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六'];
    var timerID = setInterval(updateTime, 1000);
    updateTime();

    function updateTime() {
        var cd = new Date();
        clock.time = zeroPadding(cd.getHours(), 2) + ':' + zeroPadding(cd.getMinutes(), 2) + ':' + zeroPadding(cd.getSeconds(), 2);
        clock.date = zeroPadding(cd.getFullYear(), 4) + '-' + zeroPadding(cd.getMonth() + 1, 2) + '-' + zeroPadding(cd.getDate(), 2) + ' ' + week[cd.getDay()];
    };

    function zeroPadding(num, digit) {
        var zero = '';
        for (var i = 0; i < digit; i++) {
            zero += '0';
        }
        return (zero + num).slice(-digit);
    }
</script>
<#--轮播图控制-->
<script src="${base}/dist/js/carousel.min.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript">
    carousel(
        $('#right_carousel'),	//必选， 要轮播模块(id/class/tagname均可)，必须为jQuery元素
        {
            type: 'fade',	//可选，默认左右(leftright) - 'leftright' / 'updown' / 'fade' (左右/上下/渐隐渐现)
            arrowtype: 'move',	//可选，默认一直显示 - 'move' / 'none'	(鼠标移上显示 / 不显示 )
            autoplay: true,	//可选，默认true - true / false (开启轮播/关闭轮播)
            time: 3000	//可选，默认3000
        }
    );
</script>
<#-- jQuery JS控制 -->
<script>
    $(document).ready(function () {
        <#-- right 热门文章、最新文章、新评论 jquery特效 -->
        $(".hosttest_post_a").hover(
            function () {
                $(this).prev().attr('class', 'fa fa-flag');
            },
            function () {
                $(this).prev().attr('class', 'fa fa-flag-o');
            }
        );
        $(".new_public_a").hover(
            function () {
                $(this).prev().attr('class', 'fa fa-paper-plane');
            },
            function () {
                $(this).prev().attr('class', 'fa fa-paper-plane-o');
            }
        );
        $(".new_comment_a").hover(
            function () {
                $(this).prev().attr('class', 'fa fa-commenting');
            },
            function () {
                $(this).prev().attr('class', 'fa fa-commenting-o');
            }
        );
        /* 用户右上角个人 */
        $(".dropdown").hover(
            function () {
                $(".dropdown-menu").show();
            },
            function () {
                $(".dropdown-menu").hide();
            }
        );
        /* a标签动态效果 */
        $("a").mouseover(function (e) {
            this.Mytitle = this.title;//获取超链接 title属性的内容
            this.title = ""; //设置 title属性内容为空
            $("body").append("<div id='div_toop'>" + this.Mytitle + "</div>");//将要显示的内容添加到 新建 div标签中 并追加到 body 中
            $("#div_toop")
                .css({
                    //设置 div 内容位置
                    "top": (e.pageY + 10) + "px",
                    "position": "absolute",//添加绝对位置
                    "left": (e.pageX + 20) + "px",
                    "background": "#cfe6ee",
                    "border": "0.8px solid",
                    "border-radius": "5px"
                }).show("fast");// show(spe.ed,callback) speed: xian'shi'su'du
        }).mouseout(function () { //鼠标指针从 a标签 上离开时 发生mouseout 事件
            this.title = this.Mytitle;
            $("#div_toop").remove();//移除对象
        }).mousemove(function (e) { //鼠标指针在 a标签 中移动时 发生mouseout 事件
            $("#div_toop")
                .css({
                    //设置 div 内容位置
                    "top": (e.pageY + 10) + "px",
                    "position": "absolute",//添加绝对位置
                    "left": (e.pageX + 20) + "px"
                });
        });
        $(".right_category_child").hide();
        $(".right_category_parent").click(function () {
                $(".right_category_child").slideToggle("slow");
            });
    });

</script>

