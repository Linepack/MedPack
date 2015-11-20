create or replace trigger trig_geaplica
	after insert or update or delete on geaplica
	for each row
declare
begin
	if inserting then
		for reg in (select *
						  from geperfil)
		loop
			begin
				insert into geperapl
					(sq_perapl,
					 cd_perfil,
					 cd_aplicacao,
					 st_aplicacao,
					 st_inclusao,
					 st_alteracao,
					 st_exclusao,
					 nm_usuinc,
					 dt_usuinc)
				values
					(sq_geperapl.nextval,
					 reg.cd_perfil,
					 :new.cd_aplicacao,
					 'I',
					 :new.st_inclusao,
					 :new.st_alteracao,
					 :new.st_exclusao,
					 user,
					 sysdate);
			exception
				when others then
					raise_application_error(-20000, 'Erro inserindo GEPERAPL' || chr(10) || sqlerrm);
			end;
		end loop;
	elsif updating then
		begin
			update geperapl
				set st_inclusao = :new.st_inclusao,
					 st_alteracao = :new.st_alteracao,
					 st_exclusao = :new.st_exclusao
			 where cd_aplicacao = :new.cd_aplicacao;
		exception
			when others then
				raise_application_error(-20001, 'Erro atualizando GEPERAPL' || chr(10) || sqlerrm);
		end;
	elsif deleting then
	
		begin
			delete from geperite
			 where cd_aplicacao = :new.cd_aplicacao;
		exception
			when others then
				raise_application_error(-20002, 'Erro deletando GEPERITE' || chr(10) || sqlerrm);
		end;
	
		begin
			delete from geperblk
			 where cd_aplicacao = :new.cd_aplicacao;
		exception
			when others then
				raise_application_error(-20002, 'Erro deletando GEPERBLK' || chr(10) || sqlerrm);
		end;
	
		begin
			delete from geperapl
			 where cd_aplicacao = :new.cd_aplicacao;
		exception
			when others then
				raise_application_error(-20002, 'Erro deletando GEPERAPL' || chr(10) || sqlerrm);
		end;
	end if;
end trig_geaplica;
/
