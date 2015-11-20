create or replace trigger trig_geblkite
	after insert or update or delete on geiteblk
	for each row
declare
	va_sq_perite number;
begin
	if inserting then
		for reg in (select *
						  from geperblk)
		loop
			select nvl(max(sq_perite), 0) + 1
			  into va_sq_perite
			  from geperite
			 where sq_perapl = reg.sq_perapl
				and sq_perblk = reg.sq_perblk;
		
			begin
				insert into geperite
					(sq_perapl,
					 sq_perblk,
					 sq_perite,
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
					(reg.sq_perapl,
					 reg.sq_perblk,
					 va_sq_perite,
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
