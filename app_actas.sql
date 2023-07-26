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
CREATE TEMP TABLE tmp_oferta_v2 AS
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
--and nro_acta='30376'
--and fecha_anulacion is null
and fecha_cierre > '2023-04-01' 
and fecha_cierre < '2023-07-26'
--and fecha_cierre > '2023-07-25' ULTIMO DIA QUE HICE
group by 1,2,3,4,5,6,7,8,9,10,11,12
go
---MUY IMPORTANTE HACER LO QUE SIGUE PARA QUE COINCIDA EL NUMERO DE ALUMNOS EN EL ACTA CON LO QUE ESTA EN SIU
go
CREATE TEMP TABLE tmp_oferta_v3 as
select bb.id_acta,tipo_acta,count(*) from tmp_oferta_v2 bb
inner join negocio.sga_actas_detalle de
on bb.id_acta=de.id_acta
--and instancia=2
--and nro_acta='30376'
group by 1,2
go
select * from tmp_oferta_v3
go
--UNO LAS TABLAS PARA SACAR EL TOTAL POR ACTA
select bb.cod_comision,bb.codigo,bb.nombre,bb.id_acta,bb.nro_acta,bb.estado,bb.Origen,bb.Tipo_acta,bb.fecha_cierre,bb2.count  
from tmp_oferta_v2 bb
left join tmp_oferta_v3 bb2
on bb.id_acta=bb2.id_acta
go

select comision,elemento_codigo 
from negocio.vw_comisiones where comision='90880'
