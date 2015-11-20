create or replace package PKG_PADRAO IS
  procedure PRC_COPIA_PERMISSAO_USUARIO(p_cd_usuario_destino in number,
                                        p_cd_usuario_origem  in number,
                                        p_erro               out varchar2,
                                        p_retorno            out varchar2);
  PROCEDURE PRC_GEUSUARI(P_TIPO     IN VARCHAR2,
                         P_DS_LOGIN IN VARCHAR2,
                         P_PASSWORD IN VARCHAR2,
                         P_LOCK     IN VARCHAR2,
                         P_RETORNO  OUT VARCHAR2,
                         P_ERRO     OUT VARCHAR2);
  procedure prc_filtro(p_cd_aplicacao in varchar2,
                       p_nm_bloco     in varchar2,
                       p_nm_item      in varchar2,
                       p_nr_registro  in number,
                       p_vl_item      in varchar2,
                       p_erro         out varchar2);
end pkg_padrao;
/
CREATE OR REPLACE PACKAGE BODY "PKG_PADRAO" is
  procedure PRC_COPIA_PERMISSAO_USUARIO(p_cd_usuario_destino in number,
                                        p_cd_usuario_origem  in number,
                                        p_erro               out varchar2,
                                        p_retorno            out varchar2) IS
    cursor cur_geusuapl is
      select cd_aplicacao, st_ativo, st_inclusao, st_alteracao, st_exclusao
        from geusuapl
       where cd_usuario = p_cd_usuario_origem;
  
    cursor cur_geusuapl_nivel2(p_cd_aplicacao in varchar2) is
      select nm_bloco, st_inclusao, st_alteracao, st_exclusao
        from geusuapl_nivel2
       where cd_usuario = p_cd_usuario_origem
         and cd_aplicacao = p_cd_aplicacao;
  
    cursor cur_geusuapl_nivel3(p_cd_aplicacao in varchar2,
                               p_nm_bloco     in varchar2) is
      select nm_item, st_inclusao, st_alteracao, st_obrigatorio, st_visivel
        from geusuapl_nivel3
       where cd_usuario = p_cd_usuario_origem
         and cd_aplicacao = p_cd_aplicacao
         and nm_bloco = p_nm_bloco;
  
  begin
  
    -- Primeiro deleta o que está existente (itens)-- 
    begin
      delete from geusuapl_nivel3 where cd_usuario = p_cd_usuario_destino;
    exception
      when others then
        p_erro := ('Erro deletando de GEUSUAPL_NIVEL3' || CHR(13) ||
                  sqlerrm);
        return;
    end;
  
    -- segundo deleta o que está existente (blocos)-- 
    begin
      delete from geusuapl_nivel2 where cd_usuario = p_cd_usuario_destino;
    exception
      when others then
        p_erro := ('Erro deletando de GEUSUAPL_NIVEL2' || CHR(13) ||
                  sqlerrm);
        return;
    end;
  
    -- terceiro deleta o que está existente (aplicacao)-- 
    begin
      delete from geusuapl where cd_usuario = p_cd_usuario_destino;
    exception
      when others then
        p_erro := ('Erro deletando de GEUSUAPL' || CHR(13) || sqlerrm);
        return;
    end;
  
    -- Carrega as aplicações do usuário destino --
    for reg in cur_geusuapl loop
    
      -- Depois insere a linha --
      begin
        insert into geusuapl
          (cd_usuario,
           cd_aplicacao,
           st_ativo,
           st_inclusao,
           st_alteracao,
           st_exclusao,
           nm_usuinc,
           dt_usuinc)
        values
          (p_cd_usuario_destino,
           reg.cd_aplicacao,
           reg.st_ativo,
           reg.st_inclusao,
           reg.st_alteracao,
           reg.st_exclusao,
           user,
           sysdate);
      exception
        when others then
          p_erro := ('Erro inserindo em GEUSUAPL' || chr(13) || sqlerrm);
          return;
      end;
    
      -- carregas os blocos da aplicação --
      for reg1 in cur_geusuapl_nivel2(reg.cd_aplicacao) loop
      
        -- insere o registro --
        begin
          insert into geusuapl_nivel2
            (cd_usuario,
             cd_aplicacao,
             nm_bloco,
             st_inclusao,
             st_alteracao,
             st_exclusao,
             nm_usuinc,
             dt_usuinc)
          values
            (p_cd_usuario_destino,
             reg.cd_aplicacao,
             reg1.nm_bloco,
             reg1.st_inclusao,
             reg1.st_alteracao,
             reg1.st_exclusao,
             user,
             sysdate);
        exception
          when others then
            p_erro := ('Erro inserindo em GEUSUAPL_NIVEL2' || chr(13) ||
                      sqlerrm);
            return;
        end;
      
        for reg2 in cur_geusuapl_nivel3(reg.cd_aplicacao, reg1.nm_bloco) loop
        
          -- Insere o registro --
          begin
            insert into geusuapl_nivel3
              (cd_usuario,
               cd_aplicacao,
               nm_bloco,
               nm_item,
               st_inclusao,
               st_alteracao,
               st_obrigatorio,
               st_visivel,
               nm_usuinc,
               dt_usuinc)
            values
              (p_cd_usuario_destino,
               reg.cd_aplicacao,
               reg1.nm_bloco,
               reg2.nm_item,
               reg2.st_inclusao,
               reg2.st_alteracao,
               reg2.st_obrigatorio,
               reg2.st_visivel,
               user,
               sysdate);
          exception
            when others then
              p_erro := ('Erro inserindo em GEUSUAPL_NIVEL3' || chr(13) ||
                        sqlerrm);
              return;
          end;
        
        end loop; -- for reg2 in cur_geusuapl_nivel3                        
      end loop; --for reg1 in cur_geusuapl_nivel2
    end loop; -- for reg in cur_geusuapl
  
    if p_erro is null then
      p_retorno := 'Permissões copiadas com sucesso';
      return;
    end if;
  end prc_copia_permissao_usuario;

  PROCEDURE PRC_GEUSUARI(P_TIPO     IN VARCHAR2, -- C = CRIAR, L = LOCK , P = PASSWORD
                         P_DS_LOGIN IN VARCHAR2,
                         P_PASSWORD IN VARCHAR2,
                         P_LOCK     IN VARCHAR2, -- L = LOCK, U = UNLOCK  
                         P_RETORNO  OUT VARCHAR2,
                         P_ERRO     OUT VARCHAR2) IS
  
  BEGIN
    if p_tipo = 'C' then
    
      -- Cria o usuário --
      begin
        execute immediate 'create user ' || p_ds_login || '
                          identified by ' ||
                          nvl(p_password, 'mudar') || '
                            password expire
                             DEFAULT tablespace DADOS_TABLESPACE';
      exception
        when others then
          p_ERRO := ('Erro criando usuário' || chr(13) || sqlerrm);
          return;
      end;
    
      /*     -- Grant mínimo -- 
      begin
       execute immediate 'grant connect, resource, create session, dba, linepack_role to '||p_ds_login;
      exception
       when others then
         p_ERRO := ('Erro em grant para o usuário'||chr(13)||sqlerrm);  
         return; 
      end;*/
    
      p_retorno := 'Usuário criado com Sucesso';
      return;
    
    elsif p_tipo = 'L' then
    
      -- Lock/unlock o usuário --
      if p_lock = 'L' then
        begin
          execute immediate 'alter user ' || p_ds_login || '
                             account lock';
        exception
          when others then
            p_ERRO := ('Erro fazendo lock do usuário' || chr(13) || sqlerrm);
            return;
        end;
      else
        begin
          execute immediate 'alter user ' || p_ds_login || '
                             account unlock';
        exception
          when others then
            p_ERRO := ('Erro fazendo unlock do usuário' || chr(13) ||
                      sqlerrm);
            return;
        end;
      end if;
    
      p_retorno := 'Usuário alterado com Sucesso';
      return;
    
    else
    
      -- Muda password do usuário --
      begin
        execute immediate 'alter user ' || p_ds_login || ' identified by ' ||
                          p_password;
      exception
        when others then
          p_ERRO := ('Erro alterando password do usuário' || chr(13) ||
                    sqlerrm);
          return;
      end;
    
      p_retorno := 'Password alterado com Sucesso';
      return;
    end if;
  END prc_geusuari;

  procedure prc_filtro(p_cd_aplicacao in varchar2,
                       p_nm_bloco     in varchar2,
                       p_nm_item      in varchar2,
                       p_nr_registro  in number,
                       p_vl_item      in varchar2,
                       p_erro         out varchar2) is
    pragma autonomous_transaction;
    va_cd_usuario    number;
    va_existe_filtro number;
    va_bloco         number;
  begin
    pkg_valida.prc_retorna_codigo_usuario(user, va_cd_usuario, p_Erro);
    if p_erro is not null then
      return;
    end if;
  
    begin
      select count(*)
        into va_bloco
        from gefiltro
       where cd_aplicacao = p_cd_aplicacao
         and cd_usuario = va_cd_usuario
         and nm_bloco = p_nm_bloco
         and nm_item = p_nm_item
         and nr_registro <> p_nr_registro;
    end;
  
    if va_bloco > 0 and p_nr_registro = 1 then
      begin      
        delete gefiltro
         where cd_aplicacao = p_cd_aplicacao
           and cd_usuario = va_cd_usuario
           and nm_bloco = p_nm_bloco
           and nm_item = p_nm_item;
      exception
        when others then
          p_erro := 'Erro deletando BLOCO '||p_nm_bloco||chr(10)||sqlerrm;
          rollback;
          return;
      end;
    end if;
  
    if p_vl_item is null then
      begin
        delete from gefiltro
         where cd_aplicacao = p_cd_aplicacao
           and cd_usuario = va_cd_usuario
           and nm_bloco = p_nm_bloco
           and nm_item = p_nm_item;
      exception
        when others then
          p_erro := 'Erro deletando GEFILTRO' || chr(10) || sqlerrm;
          rollback;
          return;
      end;
    
    else
    
      begin
        select count(*)
          into va_existe_filtro
          from gefiltro
         where cd_usuario = va_Cd_usuario
           and cd_aplicacao = p_cd_aplicacao
           and nm_bloco = p_nm_bloco
           and nm_item = p_nm_item
           and nr_registro = p_nr_registro;
      end;
    
      if va_existe_filtro = 0 then
        begin
          insert into gefiltro
            (sq_filtro,
             cd_usuario,
             cd_aplicacao,
             nm_bloco,
             nm_item,
             nr_registro,
             vl_item,
             nm_usuinc,
             dt_usuinc)
          values
            (sq_gefiltro.nextval,
             va_cd_usuario,
             p_Cd_aplicacao,
             p_nm_bloco,
             p_nm_item,
             p_nr_registro,
             p_vl_item,
             user,
             sysdate);
        exception
          when others then
            p_Erro := 'Erro inserindo GEFILTRO' || chr(10) || sqlerrm;
            rollback;
            return;
        end;
      else
        begin
          update gefiltro
             set vl_item = p_vl_item
           where cd_usuario = va_Cd_usuario
             and cd_aplicacao = p_cd_aplicacao
             and nm_bloco = p_nm_bloco
             and nm_item = p_nm_item
             and nr_registro = p_nr_registro;
        exception
          when others then
            p_Erro := 'Erro update GEFILTRO' || chr(10) || sqlerrm;
            rollback;
            return;
        end;
      end if;
    end if;
  
    commit;
  
  end prc_filtro;

end PKG_PADRAO;
/
