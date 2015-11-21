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
  add constraint pk_geperapl primary key (cd_perfil, cd_aplicacao)
      using index tablespace indices_tablespace;
      
create public synonym geperapl for geperapl;

grant all on geperapl to linepack_role;    


create table geperblk(
 cd_perfil number(3) not null,
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
  add constraint fk_geperblk_geperapl foreign key (cd_perfil, cd_aplicacao)
      references geperapl(cd_perfil, cd_aplicacao);  
      
create index fk_geperblk_geperapl_Ix on geperblk(cd_perfil, cd_aplicacao)
  tablespace indices_tablespace;
  
alter table geperblk
  add constraint pk_geperblk primary key (cd_perfil, cd_aplicacao, nm_bloco)
      using index tablespace indices_tablespace;
      
create public synonym geperblk for geperblk;

grant all on geperblk to linepack_role;      
            
create table geperite(
 cd_perfil number(3),       
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
  add constraint fk_geperite_geperblk foreign key (cd_perfil, cd_aplicacao, nm_bloco)
      references geperblk(cd_perfil, cd_aplicacao, nm_bloco);  

create index fk_geperite_geperblk_ix on geperite(cd_perfil, cd_aplicacao, nm_bloco)
  tablespace indices_tablespace;
          
alter table geperite
  add constraint pk_geperite primary key (cd_perfil, cd_aplicacao, nm_bloco, nm_item)
      using index tablespace indices_tablespace;
      
create public synonym geperite for geperite;

grant all on geperite to linepack_role;              
