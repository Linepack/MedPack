create table gefiltro(
 sq_filtro number(10),       
 cd_usuario number(6) not null ,
 cd_Aplicacao varchar2(8) not null ,
 nm_bloco varchar2(50) not null ,
 nm_item varchar2(50) not null ,
 nr_registro number ,
 vl_item varchar2(4000) not null,
 nm_usuinc varchar2(30) not null,
 dt_usuinc date not null,
 nm_usualt varchar2(30),
 dt_usualt date);
 
alter table gefiltro
 move tablespace dados_tablespace; 
 
alter table gefiltro 
  add constraint fk_geusuapl_gefiltro foreign key (cd_aplicacao, cd_usuario)
      references geusuapl(cd_aplicacao,cd_usuario); 
      
create index fk_geusuapl_gefiltro_ix on gefiltro(cd_aplicacao, cd_usuario)
  tablespace indices_tablespace;      
  
create public synonym gefiltro for gefiltro;

grant all on gefiltro to linepack_role;  

create sequence sq_gefiltro
increment by 1
start with 1
nocache;

create public synonym sq_gefiltro for sq_gefiltro;

grant all on gefiltro to linepack_role;
