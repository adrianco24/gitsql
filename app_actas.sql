CREATE TEMP TABLE tmp_oferta AS
select distinct per.anio_academico,per.nombre,
ele.codigo,co.comision cod_comision,co.nombre nombre_comision,
co.ubicacion cod_ubicacion, ub.nombre ubicacion
from negocio.sga_comisiones co
inner join negocio.sga_periodos_lectivos pe
on co.periodo_lectivo=pe.periodo_lectivo
inner join negocio.sga_periodos per
on per.periodo=pe.periodo
inner join negocio.sga_elementos ele
on ele.elemento=co.elemento
inner join negocio.sga_ubicaciones ub
on ub.ubicacion=co.ubicacion
inner join negocio.sga_comisiones_propuestas co_pro
on co_pro.comision=co.comision
inner join negocio.sga_propuestas pro
on pro.propuesta=co_pro.propuesta
and per.anio_academico in('2023')
and pro.propuesta IN(316,37,38,39,320,319,150,318,321)
group by per.nombre,co.comision,per.anio_academico,ele.codigo,co.nombre,
co.ubicacion, ub.nombre,pro.propuesta,
pro.nombre
order by co.comision
go
select * from tmp_oferta
GO
go

select distinct ofe.cod_comision, mat.codigo, mat.nombre,act.id_acta,nro_acta, act.estado, origen,
ofe.ubicacion,tipo_acta,fecha_cierre,ofe.nombre as periodo,ofe.nombre_comision, count(nro_acta)
from negocio.sga_actas act
inner join tmp_oferta ofe
on act.comision=ofe.cod_comision
INNER JOIN negocio.sga_elementos mat
on mat.codigo=ofe.codigo
--and origen='P'
inner join negocio.vw_insc_cursada ins
on ins.comision=act.comision
--and fecha_anulacion is null
and fecha_cierre > '2023-07-22' 
and fecha_cierre < '2023-07-25'
--and fecha_cierre > '2023-07-25' ULTIMO DIA QUE HICE
group by 1,2,3,4,5,6,7,8,9,10,11,12