create or replace trigger trig_geblkite
	after insert or update or delete on geiteblk
	for each row
declare
begin
	if inserting then
		for reg in (select *
						  from geperblk
             where cd_aplicacao = :new.cd_aplicacao
               and nm_bloco = :new.nm_bloco)
		loop			
		
			begin
				insert into geperite
					(cd_perfil,
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
					(reg.cd_perfil,
           :new.cd_aplicacao,
					 :new.nm_bloco,
					 :new.nm_item,
					 :new.st_inclusao,
					 :new.st_alteracao,
					 :new.st_obrigatorio,
					 :new.st_visivel,
					 user,
					 sysdate);
			exception
				when others then
					raise_application_error(-20000, 'Erro inserindo GEPERITE' || chr(10) || sqlerrm);
			end;
		end loop;
	elsif updating then
		begin
			update geperite
				set st_inclusao = :new.st_inclusao,
					 st_alteracao = :new.st_alteracao,
					 st_obrigatorio = :new.st_obrigatorio,
					 st_visivel = :new.st_visivel
			 where cd_aplicacao = :new.cd_aplicacao
				and nm_bloco = :new.nm_bloco
				and nm_item = :new.nm_item;
		exception
			when others then
				raise_application_error(-20001, 'Erro atualizando GEPERITE' || chr(10) || sqlerrm);
		end;
	elsif deleting then
	
		begin
			delete from geperite
			 where cd_aplicacao = :old.cd_aplicacao
				and nm_bloco = :old.nm_bloco
				and nm_item = :old.nm_item;
		exception
			when others then
				raise_application_error(-20002, 'Erro deletando GEPERITE' || chr(10) || sqlerrm);
		end;
	end if;
end trig_geaplica;
/
