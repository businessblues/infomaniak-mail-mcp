# Passerelle MCP pour Infomaniak Mail (accès depuis Claude web / iOS)
# Secrets à définir chez l'hébergeur (jamais dans ce fichier) :
#   MAIL_TOKEN            -> token API Infomaniak (scope workspace:mail)
#   SUPERGATEWAY_API_KEY  -> clé secrète que Claude enverra dans l'en-tête Authorization

FROM node:22-alpine

RUN npm install -g --omit=dev supergateway@4.3.0 @infomaniak/mcp-server-mail@2.2.0 \
 && npm cache clean --force

USER node
EXPOSE 8000

# Outils exposés : lecture, recherche, pièces jointes, brouillons, classement.
# Volontairement absents : envoi d'email, envoi de brouillon, suppressions.
CMD ["supergateway", \
     "--stdio", "mcp-server-mail", \
     "--outputTransport", "streamableHttp", \
     "--stateful", "--sessionTimeout", "900000", \
     "--port", "8000", \
     "--healthEndpoint", "/healthz", \
     "--logLevel", "none", \
     "--tools", "mail_list_mailboxes", \
     "--tools", "mail_list_folders", \
     "--tools", "mail_list_emails", \
     "--tools", "mail_read_email", \
     "--tools", "mail_search_emails", \
     "--tools", "mail_download_attachment", \
     "--tools", "mail_list_drafts", \
     "--tools", "mail_create_draft", \
     "--tools", "mail_update_draft", \
     "--tools", "mail_mark_email", \
     "--tools", "mail_flag_email", \
     "--tools", "mail_move_email", \
     "--tools", "mail_archive_email"]
