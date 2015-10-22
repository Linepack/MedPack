select * from getipope for update;

update geparame a set a.cd_tp_pessoa_paciente = 4;

commit;

create table geconsul_1(sq_consulta number(10),
                      cd_pessoa_paciente number(6),
                      dt_usuinc date not null,
                      nm_usuinc varchar2(30) not null,
                      dt_usualt date,
                      nm_usualt varchar2(30));

alter table geconsul_1 
  move tablespace dados_tablespace;
  
alter table geconsul_1
   add constraint fk_geconsul_1_gepessoa foreign key (cd_pessoa_paciente)
         references gepessoa(cd_pessoa);
           
create index fk_geconsul_1_gepessoa_ix on geconsul_1(cd_pessoa_paciente)
 tablespace indices_tablespace;
 
alter table geconsul_1
  add constraint pk_geconsul_1 primary key (sq_consulta)
  using index tablespace indices_tablespace;

create public synonym geconsul_1 for geconsul_1;

grant all on geconsul_1 to linepack_role;

create table geitecon_1(sq_consulta number(10),
                        sq_item number(4),
                        nm_caminho_arquivo varchar2(4000) not null,
                        ds_obs varchar2(4000), 
                        dt_usuinc date not null,
                        nm_usuinc varchar2(30) not null,
                        dt_usualt date,
                        nm_usualt varchar2(30));
                        
alter table geitecon_1
  add constraint fk_geitecon_1_geconsul_1 foreign key (sq_consulta)
    references geconsul_1(sq_consulta);
    
create index fk_geitecon_1_geconsul_1_ix on geitecon_1(sq_consulta)
tablespace indices_tablespace;

alter table geitecon_1
 add constraint pk_geitecon_1 primary key (sq_consulta, sq_item)
    using index tablespace indices_tablespace;

create public synonym geitecon_1 for geitecon_1;

grant all on geitecon_1 to linepack_role;                        
                        
                        
