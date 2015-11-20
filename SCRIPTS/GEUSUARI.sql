alter table geusuari
  add cd_perfil number(4);
  
alter table geusuari
  add constraint fk_geusuari_geperfil foreign key (cd_perfil)
      references geperfil(cd_perfil);
      
create index fk_geusuari_geperfil_Ix on geusuari(cd_perfil)
  tablespace indices_tablespace;
