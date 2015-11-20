create or replace trigger trig_geblkapl
	after insert or update or delete on geblkapl
	for each row
declare
	va_sq_perblk number;
begin
	if inserting then
		for reg in (select *
						  from geperapl)
		loop
			select nvl(max(sq_perblk), 0) + 1
			  into va_sq_perblk
			  from geperblk
			 where sq_perapl = reg.sq_perapl;
		
			begin
				insert into geperblk
					(sq_perapl,
					 sq_perblk,
					 cd_aplicacao,
					 nm_bloco,
					 st_inclusao,
					 st_alteracao,
					 st_exclusao,
					 nm_usuinc,
					 dt_usuinc,
					 st_salva_filtro)
				values
					(reg.sq_perapl,
					 va_sq_perblk,
					 :new.cd_aplicacao,
					 :new.nm_bloco,
					 :new.st_inclusao,
					 :new.st_alteracao,
					 :new.st_exclusao,
					 user,
					 sysdate,
					 :new.st_salva_filtro);
			exception
				when others then
					raise_application_error(-20000, 'Erro inserindo GEPERBLK' || chr(10) || sqlerrm);
			end;
		end loop;
	elsif updating then
		begin
			update geperblk
				set st_inclusao = :new.st_inclusao,
					 st_alteracao = :new.st_alteracao,
					 st_exclusao = :new.st_exclusao,
					 st_salva_filtro = :new.st_salva_filtro
			 where cd_aplicacao = :new.cd_aplicacao
				and nm_bloco = :new.nm_bloco;
		exception
			when others then
				raise_application_error(-20001, 'Erro atualizando GEPERBLK' || chr(10) || sqlerrm);
		end;
	elsif deleting then
	
		begin
			delete from geperite
			 where cd_aplicacao = :new.cd_aplicacao
				and nm_bloco = :new.nm_bloco;
		exception
			when others then
				raise_application_error(-20002, 'Erro deletando GEPERITE' || chr(10) || sqlerrm);
		end;
	
		begin
			delete from geperblk
			 where cd_aplicacao = :new.cd_aplicacao
				and nm_bloco = :new.nm_bloco;
		exception
			when others then
				raise_application_error(-20002, 'Erro deletando GEPERBLK' || chr(10) || sqlerrm);
		end;
	end if;
end trig_geaplica;
/
