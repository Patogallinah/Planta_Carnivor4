-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 13-02-2024 a las 14:58:45
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `modulo_flota`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `GenerarCodigoBarraOrdenTransporte` (IN `p_pais` VARCHAR(50), IN `p_numero_cliente` INT, OUT `p_codigo_barra` VARCHAR(255))   BEGIN
    -- Generar el código de barras utilizando el formato especificado
    SET p_codigo_barra = CONCAT(p_pais, '-', p_numero_cliente, '-', LPAD(id, 5, '0'));

    -- Insertar la orden de transporte en la tabla
    INSERT INTO ordenes_transporte (pais, numero_cliente, codigo_barra)
    VALUES (p_pais, p_numero_cliente, p_codigo_barra);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `RegistrarIngreso` (IN `p_id_personal` INT, IN `p_id_vehiculo` INT, IN `p_ubicacion_inicial` VARCHAR(255), IN `p_ubicacoin_final` VARCHAR(255))   BEGIN
    -- Insertar el registro en la tabla RendicionDocumento
    INSERT INTO rendicion_documento (id_personal, id_vehiculo, ubicacion_inical, ubicacion_final)
    VALUES (p_id_personal, p_id_vehiculo, p_ubicacion_inicial, p_ubicacion_final);

    -- Puedes agregar más lógica según tus necesidades
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `registro_moviento_conductor` (IN `p_id_vehiculo` INT, IN `p_id_conductor` INT, IN `p_ubciacion_inicial` VARCHAR(255), IN `p_ubicacion_final` VARCHAR(255))   BEGIN
    -- Insertar el registro en la tabla DireccionesVehiculosConductores
    INSERT INTO ubicacion_inicio_final (id_vehiculo, id_conductor, ubicacion_inicial, ubicacion_final)
    VALUES (p_id_vehiculo, p_id_conductor, p_ubicacion_inicial, p_ubicacion_final);
    -- Puedes agregar más lógica según tus necesidades
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `registro_moviento_log` (IN `p_accion` VARCHAR(255), IN `p_tabla_afectada` VARCHAR(255), IN `p_id_registro_afectado` INT)   BEGIN
    -- Insertar el registro en la tabla de log
    INSERT INTO registro_moviento_log (accion, tabla_afectada, id_registro_afectado, fecha_registro)
    VALUES (p_accion, p_tabla_afectada, p_id_registroAfectado, NOW());

    -- Puedes agregar más lógica según tus necesidades
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cod_ordenes_transportes`
--

CREATE TABLE `cod_ordenes_transportes` (
  `id` int(11) NOT NULL,
  `id_orden_transporte` int(11) DEFAULT NULL,
  `codigo` varchar(20) DEFAULT NULL,
  `fecha_creacion` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `conductores`
--

CREATE TABLE `conductores` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `id_vehiculo` int(11) DEFAULT NULL,
  `fecha_vencimiento_licencia` date DEFAULT NULL,
  `id_personal` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `gastos`
--

CREATE TABLE `gastos` (
  `id_gastos` int(11) NOT NULL,
  `id_vehiculo` int(11) DEFAULT NULL,
  `tipo_gasto` varchar(50) DEFAULT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `monto` decimal(10,2) DEFAULT NULL,
  `fecha_gasto` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `log_movimientos`
--

CREATE TABLE `log_movimientos` (
  `id` int(11) NOT NULL,
  `accion` varchar(255) DEFAULT NULL,
  `tabla_afectada` varchar(255) DEFAULT NULL,
  `id_registro_afectado` int(11) DEFAULT NULL,
  `fecha_registro` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `manifiesto_ot`
--

CREATE TABLE `manifiesto_ot` (
  `id` int(11) NOT NULL,
  `id_ot` int(11) DEFAULT NULL,
  `id_conductor` int(11) DEFAULT NULL,
  `patente` varchar(6) DEFAULT NULL,
  `telefono_destinatario` varchar(9) DEFAULT NULL,
  `observacion` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mantenimiento`
--

CREATE TABLE `mantenimiento` (
  `id` int(11) NOT NULL,
  `id_vehiculo` int(11) DEFAULT NULL,
  `tipo_mantenimiento` varchar(50) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `costo` decimal(10,2) DEFAULT NULL,
  `kilometraje_mantenimiento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `multas`
--

CREATE TABLE `multas` (
  `id` int(11) NOT NULL,
  `id_vehiculo` int(11) DEFAULT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `fecha_multa` date DEFAULT NULL,
  `monto` decimal(10,2) DEFAULT NULL,
  `pagada` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ordenes_transporte`
--

CREATE TABLE `ordenes_transporte` (
  `id` int(11) NOT NULL,
  `id_vehiculo` int(11) DEFAULT NULL,
  `fecha_creacion` date DEFAULT NULL,
  `origen` varchar(255) DEFAULT NULL,
  `destino` varchar(255) DEFAULT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `coste_transporte` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ordenes_transporte_boleta`
--

CREATE TABLE `ordenes_transporte_boleta` (
  `id` int(11) NOT NULL,
  `pais` varchar(50) DEFAULT NULL,
  `numero_cliente` int(11) DEFAULT NULL,
  `codigo_barra` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rendicion_documento`
--

CREATE TABLE `rendicion_documento` (
  `id` int(11) NOT NULL,
  `id_conductor` int(11) DEFAULT NULL,
  `fecha_rendicion` date DEFAULT NULL,
  `id_ot` int(11) DEFAULT NULL,
  `tipo_documento` varchar(50) DEFAULT NULL,
  `monto_pago_efectivo` decimal(10,2) DEFAULT NULL,
  `monto_gasto_conductor` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ubicacion_inicio_final`
--

CREATE TABLE `ubicacion_inicio_final` (
  `id` int(11) NOT NULL,
  `id_vehiculo` int(11) DEFAULT NULL,
  `id_conductor` int(11) DEFAULT NULL,
  `ubicacion_incial` varchar(255) DEFAULT NULL,
  `ubicacion_final` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vehiculos`
--

CREATE TABLE `vehiculos` (
  `id` int(11) NOT NULL,
  `marca` varchar(50) DEFAULT NULL,
  `modelo` varchar(50) DEFAULT NULL,
  `anio` int(11) DEFAULT NULL,
  `color` varchar(50) DEFAULT NULL,
  `patente` varchar(6) DEFAULT NULL,
  `tipo_combustible` varchar(20) DEFAULT NULL,
  `kilometraje_actual` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `cod_ordenes_transportes`
--
ALTER TABLE `cod_ordenes_transportes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `codigo` (`codigo`),
  ADD KEY `id_orden_transporte` (`id_orden_transporte`);

--
-- Indices de la tabla `conductores`
--
ALTER TABLE `conductores`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_vehiculo` (`id_vehiculo`);

--
-- Indices de la tabla `gastos`
--
ALTER TABLE `gastos`
  ADD PRIMARY KEY (`id_gastos`),
  ADD KEY `id_vehiculo` (`id_vehiculo`);

--
-- Indices de la tabla `log_movimientos`
--
ALTER TABLE `log_movimientos`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `manifiesto_ot`
--
ALTER TABLE `manifiesto_ot`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_ot` (`id_ot`);

--
-- Indices de la tabla `mantenimiento`
--
ALTER TABLE `mantenimiento`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_vehiculo` (`id_vehiculo`);

--
-- Indices de la tabla `multas`
--
ALTER TABLE `multas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_vehiculo` (`id_vehiculo`);

--
-- Indices de la tabla `ordenes_transporte`
--
ALTER TABLE `ordenes_transporte`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_vehiculo` (`id_vehiculo`);

--
-- Indices de la tabla `ordenes_transporte_boleta`
--
ALTER TABLE `ordenes_transporte_boleta`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `rendicion_documento`
--
ALTER TABLE `rendicion_documento`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_conductor` (`id_conductor`),
  ADD KEY `id_ot` (`id_ot`);

--
-- Indices de la tabla `ubicacion_inicio_final`
--
ALTER TABLE `ubicacion_inicio_final`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_vehiculo` (`id_vehiculo`),
  ADD KEY `id_conductor` (`id_conductor`);

--
-- Indices de la tabla `vehiculos`
--
ALTER TABLE `vehiculos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `patente` (`patente`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `cod_ordenes_transportes`
--
ALTER TABLE `cod_ordenes_transportes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `conductores`
--
ALTER TABLE `conductores`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `gastos`
--
ALTER TABLE `gastos`
  MODIFY `id_gastos` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `log_movimientos`
--
ALTER TABLE `log_movimientos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `manifiesto_ot`
--
ALTER TABLE `manifiesto_ot`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `mantenimiento`
--
ALTER TABLE `mantenimiento`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `multas`
--
ALTER TABLE `multas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `ordenes_transporte`
--
ALTER TABLE `ordenes_transporte`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `ordenes_transporte_boleta`
--
ALTER TABLE `ordenes_transporte_boleta`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `rendicion_documento`
--
ALTER TABLE `rendicion_documento`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `ubicacion_inicio_final`
--
ALTER TABLE `ubicacion_inicio_final`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `vehiculos`
--
ALTER TABLE `vehiculos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `cod_ordenes_transportes`
--
ALTER TABLE `cod_ordenes_transportes`
  ADD CONSTRAINT `cod_ordenes_transportes_ibfk_1` FOREIGN KEY (`id_orden_transporte`) REFERENCES `ordenes_transporte` (`id`);

--
-- Filtros para la tabla `conductores`
--
ALTER TABLE `conductores`
  ADD CONSTRAINT `conductores_ibfk_1` FOREIGN KEY (`id_vehiculo`) REFERENCES `vehiculos` (`id`);

--
-- Filtros para la tabla `gastos`
--
ALTER TABLE `gastos`
  ADD CONSTRAINT `gastos_ibfk_1` FOREIGN KEY (`id_vehiculo`) REFERENCES `vehiculos` (`id`);

--
-- Filtros para la tabla `manifiesto_ot`
--
ALTER TABLE `manifiesto_ot`
  ADD CONSTRAINT `manifiesto_ot_ibfk_1` FOREIGN KEY (`id_ot`) REFERENCES `ordenes_transporte` (`id`);

--
-- Filtros para la tabla `mantenimiento`
--
ALTER TABLE `mantenimiento`
  ADD CONSTRAINT `mantenimiento_ibfk_1` FOREIGN KEY (`id_vehiculo`) REFERENCES `vehiculos` (`id`);

--
-- Filtros para la tabla `multas`
--
ALTER TABLE `multas`
  ADD CONSTRAINT `multas_ibfk_1` FOREIGN KEY (`id_vehiculo`) REFERENCES `vehiculos` (`id`);

--
-- Filtros para la tabla `ordenes_transporte`
--
ALTER TABLE `ordenes_transporte`
  ADD CONSTRAINT `ordenes_transporte_ibfk_1` FOREIGN KEY (`id_vehiculo`) REFERENCES `vehiculos` (`id`);

--
-- Filtros para la tabla `rendicion_documento`
--
ALTER TABLE `rendicion_documento`
  ADD CONSTRAINT `rendicion_documento_ibfk_1` FOREIGN KEY (`id_conductor`) REFERENCES `conductores` (`id`),
  ADD CONSTRAINT `rendicion_documento_ibfk_2` FOREIGN KEY (`id_ot`) REFERENCES `ordenes_transporte` (`id`);

--
-- Filtros para la tabla `ubicacion_inicio_final`
--
ALTER TABLE `ubicacion_inicio_final`
  ADD CONSTRAINT `ubicacion_inicio_final_ibfk_1` FOREIGN KEY (`id_vehiculo`) REFERENCES `vehiculos` (`id`),
  ADD CONSTRAINT `ubicacion_inicio_final_ibfk_2` FOREIGN KEY (`id_conductor`) REFERENCES `conductores` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
