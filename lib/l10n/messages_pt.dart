// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a pt locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'pt';

  static m0(method, maxLength) =>
      "${method} comprimento não pode exceder ${maxLength}";

  static m1(method, minLength) =>
      "${method} tamanho não pode exceder ${minLength}";

  static m2(noteSelected) => "${noteSelected} nota selecionada";

  static m3(noteSelected) => "${noteSelected} nota selecionada";

  static m4(currentPage, totalPages) =>
      "Página ${currentPage} de ${totalPages}";

  static m5(path) => "Backup localizado em: ${path}";

  static m6(username) => "Conectado como: ${username}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "archive": MessageLookupByLibrary.simpleMessage("Arquivar"),
        "black": MessageLookupByLibrary.simpleMessage("Preto"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancelar"),
        "chooseAction": MessageLookupByLibrary.simpleMessage("Escolher ação"),
        "close": MessageLookupByLibrary.simpleMessage("Fechar"),
        "confirm": MessageLookupByLibrary.simpleMessage("Confirmar"),
        "dark": MessageLookupByLibrary.simpleMessage("Escuro"),
        "done": MessageLookupByLibrary.simpleMessage("Concluído"),
        "home": MessageLookupByLibrary.simpleMessage("Inicio"),
        "light": MessageLookupByLibrary.simpleMessage("Claro"),
        "modifyNotesRoute_color_change":
            MessageLookupByLibrary.simpleMessage("Alterar cor da nota"),
        "modifyNotesRoute_color_dialogTitle":
            MessageLookupByLibrary.simpleMessage("Seletor de cores da nota"),
        "modifyNotesRoute_content":
            MessageLookupByLibrary.simpleMessage("Conteúdo"),
        "modifyNotesRoute_image":
            MessageLookupByLibrary.simpleMessage("Imagem"),
        "modifyNotesRoute_image_add":
            MessageLookupByLibrary.simpleMessage("Adicionar imagem"),
        "modifyNotesRoute_image_remove":
            MessageLookupByLibrary.simpleMessage("Remover imagem"),
        "modifyNotesRoute_image_update":
            MessageLookupByLibrary.simpleMessage("Atualizar imagem"),
        "modifyNotesRoute_list": MessageLookupByLibrary.simpleMessage("Lista"),
        "modifyNotesRoute_list_entry":
            MessageLookupByLibrary.simpleMessage("Entrada"),
        "modifyNotesRoute_list_selectedEntries":
            MessageLookupByLibrary.simpleMessage(" entradas verificadas"),
        "modifyNotesRoute_reminder":
            MessageLookupByLibrary.simpleMessage("Lembrete"),
        "modifyNotesRoute_reminder_add":
            MessageLookupByLibrary.simpleMessage("Adicionar um novo lembrete"),
        "modifyNotesRoute_reminder_date":
            MessageLookupByLibrary.simpleMessage("Data"),
        "modifyNotesRoute_reminder_time":
            MessageLookupByLibrary.simpleMessage("Hora"),
        "modifyNotesRoute_reminder_update":
            MessageLookupByLibrary.simpleMessage("Atualizar lembrete"),
        "modifyNotesRoute_security_dialog_lengthExceed": m0,
        "modifyNotesRoute_security_dialog_lengthShort": m1,
        "modifyNotesRoute_security_dialog_titlePassword":
            MessageLookupByLibrary.simpleMessage("Definir ou atualizar senha"),
        "modifyNotesRoute_security_dialog_titlePin":
            MessageLookupByLibrary.simpleMessage("Definir ou atualizar PIN"),
        "modifyNotesRoute_security_dialog_valid":
            MessageLookupByLibrary.simpleMessage(" válido"),
        "modifyNotesRoute_security_hideContent":
            MessageLookupByLibrary.simpleMessage(
                "Ocultar conteúdo da nota na página principal"),
        "modifyNotesRoute_security_password":
            MessageLookupByLibrary.simpleMessage("Senha"),
        "modifyNotesRoute_security_pin":
            MessageLookupByLibrary.simpleMessage("PIN"),
        "modifyNotesRoute_security_protectionText":
            MessageLookupByLibrary.simpleMessage(
                "Usar uma proteção para esconder"),
        "modifyNotesRoute_title":
            MessageLookupByLibrary.simpleMessage("Título"),
        "note_archive_snackbar":
            MessageLookupByLibrary.simpleMessage("Nota arquivada"),
        "note_delete": MessageLookupByLibrary.simpleMessage("Deletar"),
        "note_delete_snackbar":
            MessageLookupByLibrary.simpleMessage("Nota excluída"),
        "note_edit": MessageLookupByLibrary.simpleMessage("Editar"),
        "note_emptyTrash":
            MessageLookupByLibrary.simpleMessage("Esvaziar lixeira"),
        "note_export": MessageLookupByLibrary.simpleMessage("Exportar"),
        "note_exportLocation":
            MessageLookupByLibrary.simpleMessage("Nota exportada em"),
        "note_lockedOptions": MessageLookupByLibrary.simpleMessage(
            "Nota bloqueada, use as opções na tela de anotações"),
        "note_pinToNotifs": MessageLookupByLibrary.simpleMessage(
            "Fixado na área de notificações"),
        "note_removeFromArchive_snackbar": MessageLookupByLibrary.simpleMessage(
            "Notas removidas de arquivados"),
        "note_restore_snackbar":
            MessageLookupByLibrary.simpleMessage("Nota restaurada"),
        "note_select": MessageLookupByLibrary.simpleMessage("Selecionar"),
        "note_share": MessageLookupByLibrary.simpleMessage("Compartilhar"),
        "note_star": MessageLookupByLibrary.simpleMessage("Favorito"),
        "note_unstar":
            MessageLookupByLibrary.simpleMessage("Remover dos Favoritos"),
        "notesMainPageRoute_emptyArchive": MessageLookupByLibrary.simpleMessage(
            "Você não tem nenhuma nota arquivada"),
        "notesMainPageRoute_emptyTrash":
            MessageLookupByLibrary.simpleMessage("Sua lixeira está vazia"),
        "notesMainPageRoute_noNotes": MessageLookupByLibrary.simpleMessage(
            "Nenhuma nota adicionada... ainda"),
        "notesMainPageRoute_note_deleteDialog_content":
            MessageLookupByLibrary.simpleMessage(
                "Uma vez que as anotações são excluídas, você não pode restaurá-las.\nTem certeza que deseja continuar?"),
        "notesMainPageRoute_note_deleteDialog_title":
            MessageLookupByLibrary.simpleMessage("Excluir notas selecionadas?"),
        "notesMainPageRoute_note_emptyTrash_content":
            MessageLookupByLibrary.simpleMessage(
                "Uma vez que as anotações são excluídas, você não pode restaurá-las.\nTem certeza que deseja continuar?"),
        "notesMainPageRoute_note_emptyTrash_title":
            MessageLookupByLibrary.simpleMessage("Esvaziar lixeira?"),
        "notesMainPageRoute_note_hiddenContent":
            MessageLookupByLibrary.simpleMessage("Conteúdo oculto"),
        "notesMainPageRoute_note_list_selectedEntries":
            MessageLookupByLibrary.simpleMessage(" itens selecionados"),
        "notesMainPageRoute_note_remindersSet":
            MessageLookupByLibrary.simpleMessage(
                "Lembretes definidos para nota"),
        "notesMainPageRoute_other":
            MessageLookupByLibrary.simpleMessage("Outras notas"),
        "notesMainPageRoute_pinnedNote":
            MessageLookupByLibrary.simpleMessage("Nota fixada"),
        "notesMainPageRoute_starred":
            MessageLookupByLibrary.simpleMessage("Notas Favoritas"),
        "notesMainPageRoute_writeNote":
            MessageLookupByLibrary.simpleMessage("Escreva uma anotação"),
        "notes_archive_snackbar":
            MessageLookupByLibrary.simpleMessage("Notas arquivadas"),
        "notes_delete_snackbar":
            MessageLookupByLibrary.simpleMessage("Notas excluídas"),
        "notes_removeFromArchive_snackbar":
            MessageLookupByLibrary.simpleMessage(
                "Notas removidas dos arquivados"),
        "notes_restore_snackbar":
            MessageLookupByLibrary.simpleMessage("Notas restauradas"),
        "remove": MessageLookupByLibrary.simpleMessage("Remover"),
        "reset": MessageLookupByLibrary.simpleMessage("Redefinir"),
        "save": MessageLookupByLibrary.simpleMessage("Salvar"),
        "searchNotesRoute_filters_case":
            MessageLookupByLibrary.simpleMessage("Maiúsculas e minúsculas"),
        "searchNotesRoute_filters_color":
            MessageLookupByLibrary.simpleMessage("Filtro de Cor"),
        "searchNotesRoute_filters_date":
            MessageLookupByLibrary.simpleMessage("Filtro de Data"),
        "searchNotesRoute_filters_title":
            MessageLookupByLibrary.simpleMessage("Filtros de pesquisa"),
        "searchNotesRoute_noQuery": MessageLookupByLibrary.simpleMessage(
            "Digite algo para iniciar a pesquisa"),
        "searchNotesRoute_nothingFound": MessageLookupByLibrary.simpleMessage(
            "Nenhuma nota encontrada que corresponda aos seus termos de pesquisa"),
        "searchNotesRoute_searchbar":
            MessageLookupByLibrary.simpleMessage("Pesquisar..."),
        "securityNoteRoute_request_password":
            MessageLookupByLibrary.simpleMessage(
                "Uma senha é solicitada para abrir a nota"),
        "securityNoteRoute_request_pin": MessageLookupByLibrary.simpleMessage(
            "Uma senha é solicitada para abrir a nota"),
        "securityNoteRoute_wrong_password":
            MessageLookupByLibrary.simpleMessage("Senha incorreta"),
        "securityNoteRoute_wrong_pin":
            MessageLookupByLibrary.simpleMessage("Senha incorreta"),
        "semantics_back": MessageLookupByLibrary.simpleMessage("Voltar"),
        "semantics_color_beige": MessageLookupByLibrary.simpleMessage("Bege"),
        "semantics_color_blue": MessageLookupByLibrary.simpleMessage("Azul"),
        "semantics_color_green": MessageLookupByLibrary.simpleMessage("Verde"),
        "semantics_color_none":
            MessageLookupByLibrary.simpleMessage("Nenhum(a)"),
        "semantics_color_orange":
            MessageLookupByLibrary.simpleMessage("Laranja"),
        "semantics_color_pink": MessageLookupByLibrary.simpleMessage("Rosa"),
        "semantics_color_purple": MessageLookupByLibrary.simpleMessage("Roxo"),
        "semantics_color_yellow":
            MessageLookupByLibrary.simpleMessage("Amarelo"),
        "semantics_hideText":
            MessageLookupByLibrary.simpleMessage("Ocultar texto"),
        "semantics_modifyNotes_addElement":
            MessageLookupByLibrary.simpleMessage("Adicionar Elemento"),
        "semantics_modifyNotes_image":
            MessageLookupByLibrary.simpleMessage("Imagem da nota"),
        "semantics_modifyNotes_security":
            MessageLookupByLibrary.simpleMessage("Opções de segurança"),
        "semantics_modifyNotes_star":
            MessageLookupByLibrary.simpleMessage("Adicionar estrela na nota"),
        "semantics_modifyNotes_unstar":
            MessageLookupByLibrary.simpleMessage("Remover estrela da Nota"),
        "semantics_notesMainPage_addNote":
            MessageLookupByLibrary.simpleMessage("Adicionar uma nova nota"),
        "semantics_notesMainPage_archive":
            MessageLookupByLibrary.simpleMessage("Arquivar notas selecionadas"),
        "semantics_notesMainPage_changeColor":
            MessageLookupByLibrary.simpleMessage("Trocar cor das notas"),
        "semantics_notesMainPage_closeSelector":
            MessageLookupByLibrary.simpleMessage("Fechar seletor"),
        "semantics_notesMainPage_delete":
            MessageLookupByLibrary.simpleMessage("Deletar notas selecionadas"),
        "semantics_notesMainPage_favouritesAdd":
            MessageLookupByLibrary.simpleMessage(
                "Adicionar notas aos favoritos"),
        "semantics_notesMainPage_favouritesRemove":
            MessageLookupByLibrary.simpleMessage("Remover notas dos favoritos"),
        "semantics_notesMainPage_grid": MessageLookupByLibrary.simpleMessage(
            "Alterado para exibição em grade"),
        "semantics_notesMainPage_list": MessageLookupByLibrary.simpleMessage(
            "Alternar para visualização em lista"),
        "semantics_notesMainPage_noteSelected": m2,
        "semantics_notesMainPage_notesSelected": m3,
        "semantics_notesMainPage_openMenu":
            MessageLookupByLibrary.simpleMessage("Abrir menu"),
        "semantics_notesMainPage_restore": MessageLookupByLibrary.simpleMessage(
            "Restaurar notas selecionadas"),
        "semantics_notesMainPage_search":
            MessageLookupByLibrary.simpleMessage("Procurar notas"),
        "semantics_showText":
            MessageLookupByLibrary.simpleMessage("Exibir Texto"),
        "semantics_welcome_exit": MessageLookupByLibrary.simpleMessage(
            "Sair da Configuração Inicial"),
        "semantics_welcome_next":
            MessageLookupByLibrary.simpleMessage("Próxima página"),
        "semantics_welcome_pageIndicator": m4,
        "semantics_welcome_previous":
            MessageLookupByLibrary.simpleMessage("Página anterior"),
        "settingsRoute_about": MessageLookupByLibrary.simpleMessage("Sobre"),
        "settingsRoute_about_potatonotes":
            MessageLookupByLibrary.simpleMessage("Sobre PotatoNotes"),
        "settingsRoute_about_potatonotes_design":
            MessageLookupByLibrary.simpleMessage(
                "Design, marca e logotipo da app por RshBfn"),
        "settingsRoute_about_potatonotes_development":
            MessageLookupByLibrary.simpleMessage(
                "Desenvolvido e mantido por HrX03"),
        "settingsRoute_about_sourceCode":
            MessageLookupByLibrary.simpleMessage("Código fonte de PotatoNotes"),
        "settingsRoute_backupAndRestore":
            MessageLookupByLibrary.simpleMessage("Restauração e Backup"),
        "settingsRoute_backupAndRestore_backup":
            MessageLookupByLibrary.simpleMessage("Backup (Experimental)"),
        "settingsRoute_backupAndRestore_backup_done": m5,
        "settingsRoute_backupAndRestore_regenDbEntries":
            MessageLookupByLibrary.simpleMessage(
                "Regenerar entradas do banco de dados"),
        "settingsRoute_backupAndRestore_restore":
            MessageLookupByLibrary.simpleMessage("Restaurar (Experimental)"),
        "settingsRoute_backupAndRestore_restore_fail":
            MessageLookupByLibrary.simpleMessage("DB corrompido ou inválido!"),
        "settingsRoute_backupAndRestore_restore_success":
            MessageLookupByLibrary.simpleMessage("Concluído!"),
        "settingsRoute_dev":
            MessageLookupByLibrary.simpleMessage("Opções do desenvolvedor"),
        "settingsRoute_dev_idLabels": MessageLookupByLibrary.simpleMessage(
            "Mostrar rótulos de identificação"),
        "settingsRoute_dev_welcomeScreen": MessageLookupByLibrary.simpleMessage(
            "Mostrar tela de boas-vindas na próxima inicialização"),
        "settingsRoute_gestures":
            MessageLookupByLibrary.simpleMessage("Gestos"),
        "settingsRoute_gestures_quickStar":
            MessageLookupByLibrary.simpleMessage(
                "Toque duas vezes em nota para adicionar aos favoritos"),
        "settingsRoute_themes": MessageLookupByLibrary.simpleMessage("Temas"),
        "settingsRoute_themes_appLanguage":
            MessageLookupByLibrary.simpleMessage("Idiomas do Aplicativo"),
        "settingsRoute_themes_appTheme":
            MessageLookupByLibrary.simpleMessage("Tema do aplicativo"),
        "settingsRoute_themes_customAccentColor":
            MessageLookupByLibrary.simpleMessage("Cor personalizada"),
        "settingsRoute_themes_followSystem":
            MessageLookupByLibrary.simpleMessage("Seguir tema do sistema"),
        "settingsRoute_themes_systemDarkMode":
            MessageLookupByLibrary.simpleMessage(
                "Modo de tema escuro automático"),
        "settingsRoute_themes_systemDefault":
            MessageLookupByLibrary.simpleMessage("Sistema"),
        "settingsRoute_themes_useCustomAccent":
            MessageLookupByLibrary.simpleMessage(
                "Usar cor personalizada de destaque"),
        "settingsRoute_title":
            MessageLookupByLibrary.simpleMessage("Configurações"),
        "syncLoginRoute_emailOrUsername":
            MessageLookupByLibrary.simpleMessage("E-mail ou nome de usuário"),
        "syncLoginRoute_emptyField": MessageLookupByLibrary.simpleMessage(
            "Este campo não pode ficar vazio!"),
        "syncLoginRoute_login":
            MessageLookupByLibrary.simpleMessage("Conectar-se"),
        "syncLoginRoute_noteConflictDialog_content":
            MessageLookupByLibrary.simpleMessage(
                "Salvar anotações e conflito de notas sincronizadas.\nO que você deseja fazer?"),
        "syncLoginRoute_noteConflictDialog_keep":
            MessageLookupByLibrary.simpleMessage(
                "Mantenha-se atualizado e faça o upload"),
        "syncLoginRoute_noteConflictDialog_replace":
            MessageLookupByLibrary.simpleMessage("Substituir salvo com nuvem"),
        "syncLoginRoute_noteConflictDialog_title":
            MessageLookupByLibrary.simpleMessage(
                "Notas encontradas em sua conta"),
        "syncLoginRoute_password":
            MessageLookupByLibrary.simpleMessage("Senha"),
        "syncLoginRoute_register":
            MessageLookupByLibrary.simpleMessage("Registrar-se"),
        "syncLoginRoute_successfulRegistration":
            MessageLookupByLibrary.simpleMessage("Registrado com sucesso"),
        "syncManageRoute_account":
            MessageLookupByLibrary.simpleMessage("Conta"),
        "syncManageRoute_account_changeImage":
            MessageLookupByLibrary.simpleMessage("Alterar Imagem"),
        "syncManageRoute_account_changeUsername":
            MessageLookupByLibrary.simpleMessage("Alterar nome de usuário"),
        "syncManageRoute_account_guest":
            MessageLookupByLibrary.simpleMessage("Convidado"),
        "syncManageRoute_account_loggedInAs": m6,
        "syncManageRoute_account_logout":
            MessageLookupByLibrary.simpleMessage("Desconectar"),
        "syncManageRoute_sync":
            MessageLookupByLibrary.simpleMessage("Sincronizar"),
        "syncManageRoute_sync_autoSyncInterval":
            MessageLookupByLibrary.simpleMessage(
                "Intervalo de tempo de sincronização automática (segundos)"),
        "syncManageRoute_sync_enableAutoSync":
            MessageLookupByLibrary.simpleMessage(
                "Habilitar Sincronização Automática"),
        "syncRegisterRoute_confirmPassword":
            MessageLookupByLibrary.simpleMessage("Confirmar a senha"),
        "syncRegisterRoute_confirmPassword_noMatch":
            MessageLookupByLibrary.simpleMessage("As senhas não conferem"),
        "syncRegisterRoute_email":
            MessageLookupByLibrary.simpleMessage("E-mail"),
        "syncRegisterRoute_email_empty": MessageLookupByLibrary.simpleMessage(
            "O e-mail não pode estar em branco"),
        "syncRegisterRoute_email_invalidFormat":
            MessageLookupByLibrary.simpleMessage("Formato de e-mail inválido"),
        "syncRegisterRoute_password":
            MessageLookupByLibrary.simpleMessage("Senha"),
        "syncRegisterRoute_password_empty":
            MessageLookupByLibrary.simpleMessage(
                "A senha não pode estar em branco"),
        "syncRegisterRoute_register":
            MessageLookupByLibrary.simpleMessage("Registrar-se"),
        "syncRegisterRoute_username":
            MessageLookupByLibrary.simpleMessage("Nome do usuário"),
        "syncRegisterRoute_username_empty":
            MessageLookupByLibrary.simpleMessage(
                "O usuário não pode estar em branco"),
        "sync_accNotFoundError":
            MessageLookupByLibrary.simpleMessage("A conta não foi encontrada"),
        "sync_dbConnectionError": MessageLookupByLibrary.simpleMessage(
            "Houve um problema na conexão com o banco de dados, tente novamente mais tarde"),
        "sync_emailAlreadyExistsError": MessageLookupByLibrary.simpleMessage(
            "O e-mail inserido já está registrado"),
        "sync_invalidCredentialsError": MessageLookupByLibrary.simpleMessage(
            "Usuário/e-mail e combinação de senha inválidos"),
        "sync_malformedEmailError": MessageLookupByLibrary.simpleMessage(
            "E-mail malformado ou ausente"),
        "sync_missingNoteIdError": MessageLookupByLibrary.simpleMessage(
            "Você não pode criar uma nota sem uma identificação"),
        "sync_notFoundError":
            MessageLookupByLibrary.simpleMessage("A conta não foi encontrada"),
        "sync_outOfBoundsError": MessageLookupByLibrary.simpleMessage(
            "O valor de entrada inserido é muito longo ou muito curto"),
        "sync_passOutOfBoundsError": MessageLookupByLibrary.simpleMessage(
            "A senha que você digitou é muito longa ou muito curta"),
        "sync_userNotFoundError": MessageLookupByLibrary.simpleMessage(
            "O usuário não foi encontrado"),
        "sync_usernameAlreadyExistsError": MessageLookupByLibrary.simpleMessage(
            "O nome de usuário inserido já está registrado"),
        "sync_usernameNotFoundError": MessageLookupByLibrary.simpleMessage(
            "Este nome de usuário não está registrado"),
        "sync_usernameOutOfBoundsError": MessageLookupByLibrary.simpleMessage(
            "O nome de usuário inserido é muito longo ou muito curto"),
        "trash": MessageLookupByLibrary.simpleMessage("Lixeira"),
        "undo": MessageLookupByLibrary.simpleMessage("Desfazer"),
        "userInfoRoute_avatar_change":
            MessageLookupByLibrary.simpleMessage("Alterar Imagem de Perfil"),
        "userInfoRoute_avatar_remove":
            MessageLookupByLibrary.simpleMessage("Remover Imagem de Perfil"),
        "userInfoRoute_sortByDate":
            MessageLookupByLibrary.simpleMessage("Ordenar notas por data"),
        "welcomeRoute_firstPage_catchPhrase":
            MessageLookupByLibrary.simpleMessage(
                "O seu novo app de notas favorito"),
        "welcomeRoute_fourthPage_description": MessageLookupByLibrary.simpleMessage(
            "E com isso você finalmente terminou. Agora você pode finalmente se divertir! Viva!"),
        "welcomeRoute_fourthPage_thankyou":
            MessageLookupByLibrary.simpleMessage(
                "Obrigado por escolher o PotatoNotes"),
        "welcomeRoute_fourthPage_title":
            MessageLookupByLibrary.simpleMessage("Configuração concluída"),
        "welcomeRoute_secondPage_title":
            MessageLookupByLibrary.simpleMessage("Personalizações Básicas"),
        "welcomeRoute_thirdPage_description": MessageLookupByLibrary.simpleMessage(
            "Com uma conta gratuita do PotatoSync, você pode sincronizar as suas notas entre vários dispositivos. E é muito fácil obter uma!"),
        "welcomeRoute_thirdPage_getStarted":
            MessageLookupByLibrary.simpleMessage("Comece agora! :)"),
        "welcomeRoute_thirdPage_success": MessageLookupByLibrary.simpleMessage(
            "O PotatoSync foi configurado com sucesso. Muito bem!")
      };
}
