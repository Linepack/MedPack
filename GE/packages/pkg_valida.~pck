create or replace package PKG_VALIDA IS
  PROCEDURE PRC_VALIDA_USUARIO(p_cd_usuario   in   number,
                               p_nm_usuario   out  varchar2,
                               p_erro         out  varchar2);
  PROCEDURE prc_retorna_codigo_usuario(p_ds_login in varchar2,
                                      p_cd_usuario out number,                                       
                                      p_erro out varchar2);                               
  PROCEDURE PRC_VALIDA_FILIAL(P_cd_fil_parameter  in   number,
                              p_cd_fil_changed    in   number,
                              p_ds_login          in   varchar2,
                              p_erro              out  varchar2,
                              p_retorno           out  varchar2);
 PROCEDURE PRC_VALIDA_DEPOSITO (P_CD_FIL    IN  NUMBER,
                                P_CD_DEP    IN  NUMBER,
                                P_ERRO      OUT VARCHAR2,
                                P_RETORNO   OUT VARCHAR2);
 PROCEDURE PRC_VALIDA_ITEM_ESMOVTO(P_CD_FIL      IN   NUMBER,
                                   P_CD_DEP      IN   NUMBER,
                                   P_CD_ITEM     IN   NUMBER,
                                   P_CD_BARRA    IN   NUMBER,
                                   P_ERRO        OUT  VARCHAR2,
                                   P_DS_ITEM     OUT  VARCHAR2,
                                   P_CD_UNIMED   OUT  VARCHAR2,
                                   P_VL_ITEM     OUT  NUMBER,
                                   P_CD_ITEM_OUT OUT  NUMBER);
 PROCEDURE PRC_VALIDA_ITEM(P_CD_FIL      IN        NUMBER,
                           P_CD_BARRA    IN        NUMBER,
                           P_CD_ITEM     IN        NUMBER,
                           P_ERRO        OUT       VARCHAR2,
                           P_DS_ITEM     OUT       VARCHAR2,
                           P_CD_UNIMED   OUT       VARCHAR2,
                           P_CD_ITEM_OUT OUT       NUMBER,
                           P_CD_DEP      OUT       NUMBER,
                           P_VL_ITEM     OUT       NUMBER);
 PROCEDURE PRC_VALIDA_TIPO_PESSOA(P_CD_TP_PESSOA IN  NUMBER,
                                  P_ERRO         OUT VARCHAR2,
                                  P_NM_TP_PESSOA OUT VARCHAR2);
 PROCEDURE PRC_VALIDA_CONDICAO(P_CD_CONDICAO   IN   NUMBER,
                               P_ERRO          OUT  VARCHAR2,
                               P_DS_CONDICAO   OUT  VARCHAR2);
 PROCEDURE PRC_VALIDA_PESSOA(P_CD_PESSOA   IN    NUMBER,
                            P_TP_PESSOA   IN    VARCHAR2, 
                            P_ERRO        OUT   VARCHAR2,
                            P_NM_FANTASIA OUT   VARCHAR2);
 PROCEDURE PRC_SUGERE_DEPOSITO_PADRAO(P_CD_FIL  IN    NUMBER,
                                      P_CD_DEP  OUT   NUMBER,
                                      P_ERRO    OUT   VARCHAR2);
 PROCEDURE PRC_VALIDA_APLICACAO(P_CD_APLICACAO   IN  VARCHAR2,
                                P_NM_APLICACAO   OUT VARCHAR2,
                                P_ERRO           OUT VARCHAR2);                                          

                                 
end pkg_VALIDA;

 
/
CREATE OR REPLACE PACKAGE BODY "PKG_VALIDA" is
 PROCEDURE PRC_VALIDA_USUARIO(p_cd_usuario  in   number,
                              p_nm_usuario  out  varchar2,
                              p_erro        out  varchar2) is
 begin

   begin
    select nm_usuario
      into p_nm_usuario
      from geusuari
     where cd_usuario = p_cd_usuario;
   exception
    when no_data_found then
      p_nm_usuario := null;
      p_erro := 'Usuário não cadastrado';
      return;
    when others then
      p_nm_usuario := null;
      p_erro := 'Erro consultando Usuário'||chr(13)||sqlerrm;
      return;
   end;
   return;
 end prc_valida_usuario;
 
 PROCEDURE prc_retorna_codigo_usuario(p_ds_login in varchar2,
                                      p_cd_usuario out number,                                       
                                      p_erro out varchar2) is
 begin

   begin
    select cd_usuario
      into p_cd_usuario
      from geusuari
     where ds_login = p_ds_login;
   exception
    when no_data_found then
      p_erro := 'Usuário não cadastrado';
      return;
    when others then
      p_erro := 'Erro consultando Usuário'||chr(13)||sqlerrm;
      return;
   end;

 end prc_retorna_codigo_usuario;
 
 PROCEDURE PRC_VALIDA_FILIAL(P_cd_fil_parameter  in   number,
                             p_cd_fil_changed    in   number,
                             p_ds_login          in   varchar2,
                             p_erro              out  varchar2,
                             p_retorno           out  varchar2) IS
  va_st_troca_filial   geusuari.st_troca_filial%type;
  va_count_geendere    number(5);
 BEGIN

  -- Verifica se o usuário altera filial --   
  begin
   select st_troca_filial
     into va_st_troca_filial
     from geusuari
    where ds_login = p_ds_login;
  exception
    when others then
       P_erro := 'Erro consultando Usuário'||CHR(13)||sqlerrm;
       return;  
  end;
  
  if va_st_troca_filial = 'N' 
    and nvl(p_cd_fil_parameter,0) <> p_cd_fil_changed then
    p_erro  := 'Você não pode alterar a Filial';
    return;
  else
  
    -- Seleciona a razão da filial --
    begin
      select nm_razao    
        into p_retorno
        from gefilial
       where cd_fil = p_cd_fil_changed;
    exception
       when no_data_found then
         p_retorno := null;
         p_erro    := 'Filial não cadastrada';
         return;
    end;
    
    -- Verifica se a filial tem endereço cadastrado --
    begin
      select count(*)
        into va_count_geendere
        from geendere
       where cd_fil = P_cd_fil_changed
         and tp_endereco = 'F';
    exception
      when others then
         p_erro := 'Erro consultando GEENDERE'||chr(13)||sqlerrm;
         return;
    end;
    
    if va_count_geendere = 0 then
       p_retorno := null;
       p_erro    := 'Filial não tem endereço de faturamento cadastrado';
       return;
    end if;     
    
    return;
    
  end if; -- if va_st_troca_filial = 'N'
  
 END prc_valida_filial;
 
 PROCEDURE PRC_VALIDA_DEPOSITO (P_CD_FIL    IN  NUMBER,
                                P_CD_DEP    IN  NUMBER,
                                P_ERRO      OUT VARCHAR2,
                                P_RETORNO   OUT VARCHAR2) IS
  va_ds_dep   esdeposi.ds_dep%type;
 BEGIN
   
   -- Seleciona o depósito --
   begin
     select ds_dep
       into va_ds_dep
       from esdeposi
      where cd_fil = p_cd_fil
        and cd_dep = p_cd_dep;
   exception
     when no_data_found then
        p_retorno := null;
        p_erro    := 'Depósito não cadastrado';
        return;
     when others then
        p_retorno := null;
        p_erro    := 'Erro consutlando ESDEPOSI'||chr(13)||sqlerrm;
        return;   
   end;
   
   p_retorno := va_ds_dep;
   return;
 
 END PRC_VALIDA_DEPOSITO;
 
 PROCEDURE PRC_VALIDA_ITEM_ESMOVTO(P_CD_FIL      IN   NUMBER,
                                   P_CD_DEP      IN   NUMBER,
                                   P_CD_ITEM     IN   NUMBER,
                                   P_CD_BARRA    IN   NUMBER,
                                   P_ERRO        OUT  VARCHAR2,
                                   P_DS_ITEM     OUT  VARCHAR2,
                                   P_CD_UNIMED   OUT  VARCHAR2,
                                   P_VL_ITEM     OUT  NUMBER,
                                   P_CD_ITEM_OUT OUT  NUMBER) IS
   va_st_item          esitemes.st_item%type;
   va_existe_esdepite  number(1);
 BEGIN
   
  -- Pega descrição, Unidade de medida, preço... do item -- 
  begin
    select a.ds_item,
           a.cd_unimed,
           a.vl_item,
           a.cd_item,
           a.st_item
      into p_ds_item,
           p_cd_unimed,
           p_vl_item,
           p_cd_item_out,
           va_st_item
      from esitemes a
     where (a.cd_item = p_cd_item or a.cd_barra = p_cd_barra);
  exception
    when no_data_found then
       p_ds_item      := null;
       p_cd_unimed    := null;
       p_vl_item      := null;
       p_cd_item_out  := null;
       p_erro         := 'Item não cadastrado';
       return;
    when others then
       p_ds_item      := null;
       p_cd_unimed    := null;
       p_vl_item      := null;
       p_cd_item_out  := null;
       p_erro         := 'Erro consutlando Item'||chr(13)||sqlerrm;
       return;   
  end; 
  
  if va_st_item != 'A' then
     p_ds_item      := null;
     p_cd_unimed    := null;
     p_vl_item      := null;
     p_cd_item_out  := null;
     p_erro         := 'Item está Inativo';
     return;
  end if;
  
  -- Verifica se o item existe no depósito indicado --
  begin
    select count(*)
      into va_existe_esdepite
      from esdepite a,
           esitemes b
     where a.cd_item = b.cd_item
       and a.cd_fil  = p_cd_fil
       and a.cd_dep  = p_cd_dep
       and (a.cd_item = p_cd_item or b.cd_barra = p_cd_barra) ;
  exception
    when others then
       p_erro := 'Erro consultando ESDEPITE'||chr(13)||sqlerrm;     
       return;
  end;     
       
  if va_existe_esdepite = 0 then
     p_ds_item      := null;
     p_cd_unimed    := null;
     p_vl_item      := null;
     p_cd_item_out  := null;
     p_erro         := 'Item não está vinculado a esta Filial/Depósito';
     return;
  end if;
  
  return;
  
 END PRC_VALIDA_ITEM_ESMOVTO;
 
 PROCEDURE PRC_VALIDA_ITEM(P_CD_FIL      IN        NUMBER,
                           P_CD_BARRA    IN        NUMBER,
                           P_CD_ITEM     IN        NUMBER,
                           P_ERRO        OUT       VARCHAR2,
                           P_DS_ITEM     OUT       VARCHAR2,
                           P_CD_UNIMED   OUT       VARCHAR2,
                           P_CD_ITEM_OUT OUT       NUMBER,
                           P_CD_DEP      OUT       NUMBER,
                           P_VL_ITEM     OUT       NUMBER) IS
  va_st_item  esitemes.st_item%type;
 BEGIN
   -- seleciona a descrição do item --
   begin
     select ds_item,
            cd_unimed,
            st_item,
            cd_item,
            vl_item
       into p_ds_item,
            p_cd_unimed,
            va_st_item,
            p_cd_item_out,
            p_vl_item
       from esitemes
      where (cd_item = p_cd_item or cd_barra = p_cd_barra);
   exception
     when no_data_found then
       p_ds_item   := null;
       p_cd_unimed := null;
       p_cd_dep    := null;
       p_vl_item   := null;
       p_erro      := 'Item não cadastrado';
       return;
     when others then
       p_ds_item   := null;
       p_cd_unimed := null;
       p_cd_dep    := null;
       p_vl_item   := null;
       p_erro      := 'Erro consultando ESITEMES'||chr(10)||sqlerrm;
       return;  
   end;    
   
   -- Item está ativo ?--
   if va_st_item <> 'A' then
      p_ds_item   := null;
      p_cd_unimed := null;
      p_cd_dep    := null;
      p_vl_item   := null;
      p_erro      := 'Item está Inativo';
      return;  
   end if;
   
   -- Verifica e sugere o depósito inserido primeiro --
   if p_cd_fil is not null then
     begin
       select a.cd_dep
         into p_cd_dep
         from esdeposi a,
              esdepite b
        where a.cd_fil  = b.cd_fil
          and a.cd_dep  = b.cd_dep
          and b.cd_fil  = p_cd_fil
          and b.cd_item = nvl(p_cd_item, (select cd_item
                                           from esitemes
                                          where cd_barra = p_cd_barra))
          and a.st_padrao_vendas = 'S';
     exception
       when no_data_found then
          p_cd_dep := null;
     end;
   end if; -- if p_cd_fil is not null then
       
   return;
 
 END PRC_VALIDA_ITEM;
 
 PROCEDURE PRC_VALIDA_TIPO_PESSOA(P_CD_TP_PESSOA IN  NUMBER,
                                  P_ERRO         OUT VARCHAR2,
                                  P_NM_TP_PESSOA OUT VARCHAR2) IS
 BEGIN
   --  seleciona a descricao do tp pessoa--
   begin
     select nm_tp_pessoa
       into p_nm_tp_pessoa
       from getipope
      where cd_tp_pessoa = p_cd_tp_pessoa;
   exception
     when no_data_found then
       p_nm_tp_pessoa := null;
       p_erro         := 'Tipo de pessoa não cadatsrado';
       return;
     when others then
       p_nm_tp_pessoa := null;
       p_erro         := 'Erro consultando GETIPOPE'||chr(13)||sqlerrm;
       return;  
   end;
   
   return;    
       
 END PRC_VALIDA_TIPO_PESSOA;
 
 PROCEDURE PRC_VALIDA_CONDICAO(P_CD_CONDICAO   IN   NUMBER,
                               P_ERRO          OUT  VARCHAR2,
                               P_DS_CONDICAO   OUT  VARCHAR2) IS
 BEGIN
   -- Seleciona a descrição da condição de pagamento --
   begin
     select ds_condicao
       into p_ds_condicao
       from geconpag
      where cd_condicao = p_cd_condicao;
   exception 
     when no_data_found then
        p_ds_condicao := null;
        p_erro        := 'Condiçãode pagamento não cadastrada';
        return;
     when others then
        p_ds_condicao := null;
        p_erro        := 'Erro consultando GECONPAG'||chr(13)||sqlerrm;
        return;
   end;
   
   return;
           
 END PRC_VALIDA_CONDICAO;
 
 PROCEDURE PRC_VALIDA_PESSOA(P_CD_PESSOA   IN    NUMBER,
                             P_TP_PESSOA   IN    VARCHAR2, 
                             P_ERRO        OUT   VARCHAR2,
                             P_NM_FANTASIA OUT   VARCHAR2) IS
  /*
  O parametro P_TP_PESSOA pode ter os seguintes valores:
  C = CLIENTE
  V = VENDEDOR
  M = MEDICO
  P = PACIENTE
  */
  va_st_pessoa          gepessoa.st_pessoa%type;
  va_count_geendere     number(5);
 BEGIN
   -- Seleciona dados da pessoa --
   begin
     select a.nm_fantasia,
            a.st_pessoa
       into p_nm_fantasia,
            va_st_pessoa
       from gepessoa a,
            getippes b
      where a.cd_pessoa    = b.cd_pessoa
        and a.cd_pessoa    = p_cd_pessoa
        and b.cd_tp_pessoa = (select decode(p_tp_pessoa,'V',cd_tp_pessoa_vendedor,
                                                        'C',cd_tp_pessoa_cliente,
                                                        'M',cd_tp_pessoa_medico,
                                                        'P',cd_tp_pessoa_paciente)
                                from geparame);
   exception
     when no_data_found then
       p_nm_fantasia := null;
       p_erro        := 'Pessoa não cadastrada';
       return;
     when others then  
       p_nm_fantasia := null;
       p_erro        := 'Erro consultando GEPESSOA'||chr(13)||sqlerrm;
       return;
   end;
   
   -- Ativo ?--
   if va_st_pessoa != 'A' then
      p_nm_fantasia := null;
      p_erro        := 'Pessoa está inativa';
      return;
   end if; 
   
   begin
     select count(*)
       into va_count_geendere
       from geendere
      where cd_pessoa   = p_cd_pessoa
        and tp_endereco = 'F';
   exception
     when others then
       p_nm_fantasia := null;
       p_erro        := 'Erro consultando GEENDERE'||chr(13)||sqlerrm;
       return;     
   end;
   
   -- Endereço de faturamento ? --
   if va_count_geendere = 0 then
      p_nm_fantasia := null;
      p_erro        := 'Pessoa sem endereço de Faturamento cadastrado';
      return;
   end if;
       
   return;
                        
 END PRC_VALIDA_PESSOA;
 
 PROCEDURE PRC_SUGERE_DEPOSITO_PADRAO(P_CD_FIL  IN    NUMBER,
                                      P_CD_DEP  OUT   NUMBER,
                                      P_ERRO    OUT   VARCHAR2) IS
 BEGIN
   --Seleciona o depósito -- 
   begin
     select cd_dep
       into p_cd_dep
       from esdeposi
      where cd_fil           = p_cd_fil
        and st_padrao_vendas = 'S';
   exception
     when no_data_found then
       p_cd_dep := null;
       return;
     when others then
       p_erro   := 'Erro consultando ESDEPOSI'||chr(13)||sqlerrm;
       P_cd_dep := null;
       return;
   end;
   
   return;   

 END PRC_SUGERE_DEPOSITO_PADRAO;
 
 PROCEDURE PRC_VALIDA_APLICACAO(P_CD_APLICACAO IN  VARCHAR2,
                                P_NM_APLICACAO OUT VARCHAR2,
                                P_ERRO         OUT VARCHAR2) IS
                                
 BEGIN
   
   begin  
     select nm_aplicacao
       into p_nm_aplicacao
       from geaplica
      where cd_aplicacao = P_CD_APLICACAO;
   exception
     when no_data_found then
          p_erro := 'Aplicação não cadastrada';
          return;
     when others then
          p_erro := 'Erro consultando GEAPLICA'||chr(10)||sqlerrm;
          return;      
   end;    
   
 END PRC_VALIDA_APLICACAO;
                                 
 
end PKG_VALIDA;
/
