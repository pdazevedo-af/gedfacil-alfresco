<style>
   /* Limpeza e Centralização do Rodapé */
   .footer {
      background-color: #565555ed !important;
      color: #FFFFFF !important;
      border-top: 4px solid #de171a !important;
      text-align: center !important;
      padding: 15px 0 !important;
      height: auto !important;
      max-height: 50px !important;
      width: 100% !important;
      position: relative !important;
      left: 0 !important;
      right: 0 !important;
      display: block !important;
   }

   .footer-info {
      display: block !important;
      margin: 0 auto !important;
      text-align: center !important;
      width: 100% !important;
   }

   .support-text {
      font-size: 13px !important;
      margin-bottom: 5px !important;
      color: #FFFFFF !important;
   }

   .brand-text {
      font-size: 13px !important;
      font-weight: bold !important;
      color: #FFFFFF !important;
   }

   /* Esconder links padrão do Alfresco que podem estar sobrando */
   .footer .copyright {
      display: none !important;
   }
</style>

<div class="footer">
   <div class="footer-info">
      <div class="support-text">${msg("label.support")}</div>
      <div class="brand-text">${msg("label.brand")}</div>
   </div>
</div>
