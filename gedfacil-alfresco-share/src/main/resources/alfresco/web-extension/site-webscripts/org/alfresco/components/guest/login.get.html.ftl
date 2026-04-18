<@markup id="css" >
   <#-- CSS Dependencies -->
   <@link href="${url.context}/res/components/guest/login.css" group="login"/>
   <link rel="shortcut icon" href="${url.context}/res/gedfacil-alfresco-share/images/favicon.ico" />
   <link rel="icon" type="image/x-icon" href="${url.context}/res/gedfacil-alfresco-share/images/favicon.ico" />
   <style>
      .theme-overlay.login .theme-company-logo {
         background-image: none !important;
         text-align: center;
         height: auto !important;
         padding: 10px 0 20px 0;
         width: auto;
      }
      .theme-overlay.login .product-name {
         color: #de171a !important; /* Cor padrão vermelha da logomarca */
         font-size: 32px !important;
         font-weight: bold !important;
         text-align: center !important;
         padding: 0 !important;
         display: block !important;
      }
      .theme-overlay.login .product-tagline {
         text-align: center !important;
         color: #555 !important;
         font-size: 16px !important;
         display: block !important;
         visibility: visible !important;
         margin-top: 10px !important;
      }
      /* Fundo branco com pequenos pixels vermelhos */
      body.theme-body, body, html {
         background-color: #f7f7f7 !important;
         background-image: none !important;
      }
      .theme-overlay.login .product-community {
         display: none !important;
      }
      /* Ajustar as cores da tela de login para refletir a marca */
      .theme-overlay.login {
         border-top: 5px solid #de171a !important; 
         box-shadow: 0 15px 35px rgba(0,0,0,0.15) !important;
         border-radius: 12px !important;
         background-color: rgba(255, 255, 255, 0.98) !important;
      }
      .login-button, 
      button.login-button, 
      input[type="submit"].login-button,
      span[id*="submit-button"], 
      span[id*="submit-button"] button,
      .yui-button.yui-submit-button,
      .yui-button.yui-submit-button button {
         background-color: #de171a !important;
         background-image: none !important;
         border-color: #aa1012 !important;
         color: white !important;
         box-shadow: none !important;
         text-shadow: none !important;
      }
      .login-button:hover,
      .yui-button.yui-submit-button:hover,
      .yui-button.yui-submit-button button:hover {
         background-color: #aa1012 !important;
      }
   </style>
</@>

<@markup id="js">
   <#-- JavaScript Dependencies -->
   <@script src="${url.context}/res/components/guest/login.js" group="login"/>
</@>

<@markup id="widgets">
   <@createWidgets group="login"/>
</@>

<@markup id="html">
   <@uniqueIdDiv>
      <#assign el=args.htmlid?html>
      <div id="${el}-body" class="theme-overlay login hidden">
      
      <@markup id="header">
         <div class="theme-company-logo">
            <img src="${url.context}/res/gedfacil-alfresco-share/images/logomarca.png" alt="Logomarca" style="max-height: 80px; width: auto; max-width: 100%; display: block; margin: 0 auto;"/>
         </div>
         <div class="product-name">GEDfácil</div>
         <div class="product-tagline" style="font-size: 16px; margin-top: 10px;">Armazenamento digital seguro e eficiente</div>
      </@markup>
      
      <#if errorDisplay == "container">
      <@markup id="error">
         <#if error>
         <div class="error">${msg("message.loginautherror")}</div>
         <#else>
         <script type="text/javascript">//<![CDATA[
            <#assign cookieHeadersConfig = config.scoped["COOKIES"] />
            <#if cookieHeadersConfig?? && (cookieHeadersConfig.secure.getValue() == "true" || cookieHeadersConfig.secure.getValue() == "false")>
               Alfresco.constants.secureCookie = ${cookieHeadersConfig.secure.getValue()};
               Alfresco.constants.sameSite = "${cookieHeadersConfig.sameSite.getValue()}";
            </#if>

            var cookieDefinition = "_alfTest=_alfTest; Path=/;";
            if(Alfresco.constants.secureCookie)
            {
               cookieDefinition += " Secure;";
            }
            if(Alfresco.constants.sameSite)
            {
               cookieDefinition += " SameSite="+Alfresco.constants.sameSite+";";
            }
            document.cookie = cookieDefinition;

            var cookieEnabled = (document.cookie.indexOf("_alfTest") !== -1);
            if (!cookieEnabled)
            {
               document.write('<div class="error">${msg("message.cookieserror")}</div>');
            }
         //]]></script>
         </#if>
      </@markup>
      </#if>
      
      <@markup id="form">
         <form id="${el}-form" accept-charset="UTF-8" method="post" action="${loginUrl}" class="form-fields login">
            <@markup id="fields">
            <input type="hidden" id="${el}-success" name="success" value="${successUrl?replace("@","%40")?html}"/>
            <input type="hidden" name="failure" value="${failureUrl?replace("@","%40")?html}"/>
            <div class="form-field">
               <input type="text" id="${el}-username" name="username" maxlength="255" value="<#if lastUsername??>${lastUsername?html}</#if>" placeholder="${msg("label.username")}" />
            </div>
            <div class="form-field">
               <input type="password" id="${el}-password" name="password" maxlength="255" placeholder="${msg("label.password")}" />
            </div>
            </@markup>
            <@markup id="buttons">
            <div class="form-field">
               <input type="submit" id="${el}-submit" class="login-button" value="${msg("button.login")}"/>
            </div>
            </@markup>
         </form>
      </@markup>
      
      <@markup id="preloader">
         <script type="text/javascript">//<![CDATA[
            window.onload = function() 
            {
                setTimeout(function()
                {
                    var xhr;
                    <#list dependencies as dependency>
                       xhr = new XMLHttpRequest();
                       xhr.open('GET', '<@checksumResource src="${url.context}/res/${dependency}"/>');
                       xhr.send('');
                    </#list>
                    <#list images as image>
                       new Image().src = "${url.context?js_string}/res/${image}";
                    </#list>
                }, 1000);
            };
         //]]></script>
      </@markup>

      </div>
      
      <@markup id="footer">
      </@markup>
   </@>
</@>
