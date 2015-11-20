create table geperfil(
  cd_perfil number(3),
  ds_perfil varchar2(500) not null,
  nm_usuinc varchar2(30) not null,
  dt_usuinc date not null,
  nm_usualt varchar2(30),
  dt_usualt date);
  
alter table geperfil
  move tablespace dados_tablespace;
  
alter table geperfil 
  add constraint pk_geperfil primary key (cd_perfil)
      using index tablespace indices_tablespace;
      
create public synonym geperfil for geperfil;

grant all on geperfil to linepack_role;        

create table geperapl(
 sq_perapl number(10),
 cd_perfil number(3) not null,
 cd_aplicacao varchar2(8) not null,
 st_aplicacao char(1) not null,
 st_inclusao char(1) not null,
 st_alteracao char(1) not null,
 st_exclusao char(1) not null,
 nm_usuinc varchar2(30) not null,
 dt_usuinc date not null,
 nm_usualt varchar2(30),
 dt_usualt date);
 
alter table geperapl 
  move tablespace dados_tablespace;
  
alter table geperapl
  add constraint fk_geperapl_geperfil foreign key (cd_perfil)
      references geperfil(cd_perfil);   

create index fk_geperapl_geperfil_ix on geperapl(cd_perfil)
  tablespace indices_tablespace;
  
alter table geperapl
  add constraint fk_geperapl_geaplica foreign key (cd_aplicacao)
      references geaplica(cd_aplicacao);

create index fk_geperapl_geaplica_ix on geperapl(cd_aplicacao)
  tablespace indices_tablespace;
  
alter table geperapl
  add constraint pk_geperapl primary key (sq_perapl)
      using index tablespace indices_tablespace;
      
create public synonym geperapl for geperapl;

grant all on geperapl to linepack_role;    


create table geperblk(
 sq_perapl number(10),
 sq_perblk number(5),
 cd_aplicacao varchar2(8) not null,
 nm_bloco varchar2(8) not null,
 st_inclusao char(1) not null,
 st_alteracao char(1) not null ,
 st_exclusao char(1) not null,
 st_salva_filtro char(1) not null,
 nm_usuinc varchar2(30) not null,
 dt_usuinc date not null,
 nm_usualt varchar2(30),
 dt_usualt date);  
  
alter table geperblk
 move tablespace dados_tablespace;
 
alter table geperblk
  add constraint fk_geperblk_geaplica foreign key (cd_aplicacao)
      references geaplica(cd_aplicacao); 
 
create index fk_geperblk_geaplica_ix on geperblk(cd_aplicacao)
  tablespace indices_tablespace;
  
alter table geperblk
  add constraint fk_geperblk_geperapl foreign key (sq_perapl)
      references geperapl(sq_perapl);  
      
create index fk_geperblk_geperapl_Ix on geperblk(sq_perapl)
  tablespace indices_tablespace;
  
alter table geperblk
  add constraint pk_geperblk primary key (sq_perapl, sq_perblk)
      using index tablespace indices_tablespace;
      
create public synonym geperblk for geperblk;

grant all on geperblk to linepack_role;      
            
create table geperite(
 sq_perapl number(10),
 sq_perblk number(5),
 sq_perite number(5),
 cd_aplicacao varchar2(8) not null,
 nm_bloco varchar2(8) not null,
 nm_item varchar2(30) not null,
 st_inclusao char(1) not null,
 st_alteracao char(1) not null ,
 st_obrigatorio char(1) not null,
 st_visivel char(1) not null,
 nm_usuinc varchar2(30) not null,
 dt_usuinc date not null,
 nm_usualt varchar2(30),
 dt_usualt date);  
 
alter table geperite
 move tablespace dados_tablespace;
 
alter table geperite
  add constraint fk_geperite_geperblk foreign key (sq_perapl, sq_perblk)
      references geperblk(sq_perapl,sq_perblk);  

create index fk_geperite_geperblk_ix on geperite(sq_perapl, sq_perblk)
  tablespace indices_tablespace;
  
alter table geperite
  add constraint fk_geperite_geaplica foreign key (cd_aplicacao)
      references geaplica(cd_aplicacao);  
      
create index fk_geperite_geaplica_ix on geperite(cd_aplicacao)
  tablespace indices_tablespace;
  
alter table geperite
  add constraint pk_geperite primary key (sq_perapl, sq_perblk, sq_perite)
      using index tablespace indices_tablespace;
      
create public synonym geperite for geperite;

grant all on geperite to linepack_role;              

create sequence sq_geperapl
increment by 1
start with 1
nocache;

create public synonym sq_geperapl for sq_geperapl;

grant all on sq_geperapl to linepack_role;
