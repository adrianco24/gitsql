----Creamos una table temporal de la oferta
CREATE TEMP TABLE tmp_oferta AS
(select per.nombre periodo_lectivo,ele.codigo cod_materia,ele.nombre materia, co.nombre nombre_comision, co.comision cod_comision,co.ubicacion cod_ubicacion, ub.nombre ubicacion
from negocio.sga_comisiones co
inner join negocio.sga_periodos_lectivos pe
on co.periodo_lectivo=pe.periodo_lectivo
inner join negocio.sga_periodos per
on per.periodo=pe.periodo
inner join negocio.sga_elementos ele
on ele.elemento=co.elemento
inner join negocio.sga_ubicaciones ub
on ub.ubicacion=co.ubicacion
and per.anio_academico='2021'
and per.nombre in
('DCHG-Segundo Cuatri. EXT','DCHG-Anual S.C','DCHG-Primer Cuatrimestre','DCHG-Sementre SC', 'DCHG-Cuatrimestral SC','DCHG-PC anual','DCHG-PC semest'))

go

--Agrupo para ver totales
select periodo_lectivo,cod_materia,materia,cod_ubicacion,ubicacion ,count(*)
from tmp_oferta group by periodo_lectivo,cod_materia,materia,cod_ubicacion,ubicacion
order by ubicacion

----Por ubicacion
select periodo_lectivo,ubicacion ,count(*)
from tmp_oferta group by periodo_lectivo,ubicacion
order by ubicacion