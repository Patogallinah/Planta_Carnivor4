-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 13-02-2024 a las 14:59:09
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
-- Base de datos: `modulo_personal`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `CambiarContrasenaConVerificacionYLog` (IN `p_id_usuario` INT, IN `p_contrasena_anterior` VARCHAR(255), IN `p_nueva_contrasena` VARCHAR(255), OUT `p_cambio_exitoso` BOOLEAN)   BEGIN
    DECLARE contrasena_valida BOOLEAN;

    -- Validar la contraseña anterior
    CALL ValidarContrasenaConLog(p_id_usuario, p_contrasena_anterior, contrasena_valida);

    IF contrasena_valida THEN
        -- Actualizar la contraseña con la nueva contraseña
        UPDATE usuarios SET contrasena = SHA2(p_nueva_contrasena, 256) WHERE id = p_id_usuario;
        SET p_cambio_exitoso = TRUE;

        -- Registrar el cambio de contraseña en el log
        INSERT INTO log_personal (fecha_registro, tipo_evento, descripcion)
        VALUES (NOW(), 'CambioContrasena', CONCAT('Cambio de contraseña exitoso para usuario ', p_usuario_id));
    ELSE
        SET p_cambio_exitoso = FALSE;

        -- Registrar el intento de cambio de contraseña fallido en el log
        INSERT INTO log_personal (fecha_registro, tipo_evento, descripcion)
        VALUES (NOW(), 'IntentoCambioContrasena', CONCAT('Intento de cambio de contraseña fallido para usuario ', p_id_usuario));
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ValidarContrasenaConLog` (IN `p_id_usuario` INT, IN `p_contrasena_ingresada` VARCHAR(255), OUT `p_valido` BOOLEAN)   BEGIN
    DECLARE hash_guardado VARCHAR(255);

    -- Obtener la contraseña almacenada para el usuario
    SELECT contrasena INTO hash_guardado FROM usuarios WHERE id = p_id_usuario;

    -- Validar la contraseña ingresada comparándola con la almacenada
    SET p_valido = (hash_guardado = SHA2(p_contrasena_ingresada, 256));

    -- Registrar el intento de validación en el log
    INSERT INTO log (fecha_registro, tipo_evento, descripcion)
    VALUES (NOW(), 'ValidacionContrasena', CONCAT('Intento de validación de contraseña para usuario ', p_id_usurio, ': ', IF(p_valido, 'Éxito', 'Fallo')));
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `afp`
--

CREATE TABLE `afp` (
  `id` int(11) NOT NULL,
  `nombre_afp` varchar(100) DEFAULT NULL,
  `comision` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `afp`
--

INSERT INTO `afp` (`id`, `nombre_afp`, `comision`) VALUES
(1, 'AFP Capital', 1.44),
(2, 'AFP Cuprum', 1.44),
(3, 'AFP Habitat', 1.27),
(4, 'AFP Modelo', 0.58),
(5, 'AFP Planvital', 1.16),
(6, 'AFP Provida', 1.45),
(7, 'AFP Uno', 0.49);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cargos`
--

CREATE TABLE `cargos` (
  `id` int(11) NOT NULL,
  `nombre_cargo` varchar(100) DEFAULT NULL,
  `descripcion` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `cargos`
--

INSERT INTO `cargos` (`id`, `nombre_cargo`, `descripcion`) VALUES
(1, 'Desarrollo y Soporte TI', 'Desarrollador de software personalizado y soporte tecnico a la empresa');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ciudades`
--

CREATE TABLE `ciudades` (
  `id` int(11) NOT NULL,
  `nombre_ciudad` varchar(100) DEFAULT NULL,
  `id_comuna` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `comunas`
--

CREATE TABLE `comunas` (
  `id` int(11) NOT NULL,
  `nombre_comuna` varchar(100) DEFAULT NULL,
  `id_region` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `comunas`
--

INSERT INTO `comunas` (`id`, `nombre_comuna`, `id_region`) VALUES
(6, 'Iquique', 1),
(7, 'Antofagasta', 2),
(8, 'Copiapo', 3),
(9, 'La Serena', 4),
(10, 'Valparaiso', 5),
(11, 'Rancagua', 6),
(12, 'Talca', 7),
(13, 'Concepcion', 8),
(14, 'Temuco', 9),
(15, 'Pueto Montt', 10),
(16, 'Coyhaique', 11),
(17, 'Punta Arenas', 12),
(18, 'Santiago', 0),
(19, 'Valdivia', 14),
(20, 'Arica', 15),
(21, 'Chillan', 16);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cotizaciones`
--

CREATE TABLE `cotizaciones` (
  `id` int(11) NOT NULL,
  `fecha_cotizacion` date DEFAULT NULL,
  `cliente_id` int(11) DEFAULT NULL,
  `empleado_id` int(11) DEFAULT NULL,
  `total_cotizado` decimal(10,2) DEFAULT NULL,
  `estado_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `departamentos`
--

CREATE TABLE `departamentos` (
  `id` int(11) NOT NULL,
  `nombre_departamento` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `departamentos`
--

INSERT INTO `departamentos` (`id`, `nombre_departamento`) VALUES
(1, 'Casa Matriz: Los Angeles'),
(2, 'Sucursal: Santiago');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `direcciones`
--

CREATE TABLE `direcciones` (
  `id` int(11) NOT NULL,
  `calle` varchar(255) DEFAULT NULL,
  `id_ciudad` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `emails`
--

CREATE TABLE `emails` (
  `id` int(11) NOT NULL,
  `correo` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empleados`
--

CREATE TABLE `empleados` (
  `id` int(11) NOT NULL,
  `id_persona` int(11) NOT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `apellido` varchar(100) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `fecha_contratacion` date NOT NULL,
  `salario` int(11) NOT NULL,
  `gratificaciones` int(11) NOT NULL,
  `id_cargo` int(11) DEFAULT NULL,
  `id_estado_personal` int(11) NOT NULL,
  `id_departamento` int(11) DEFAULT NULL,
  `id_salud` int(11) DEFAULT NULL,
  `id_cotizacion` int(11) NOT NULL,
  `id_afp` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estado_personal`
--

CREATE TABLE `estado_personal` (
  `id` int(11) NOT NULL,
  `codigo_estado` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `estado_personal`
--

INSERT INTO `estado_personal` (`id`, `codigo_estado`) VALUES
(1, 'Activo'),
(2, 'Inactivo'),
(3, 'En Licencia'),
(4, 'vacaciones'),
(5, 'Periodo de Prueba'),
(6, 'Renuncia'),
(7, 'Desviculado'),
(8, 'Jubilado'),
(9, 'Suspendido');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `historial_laboral`
--

CREATE TABLE `historial_laboral` (
  `id` int(11) NOT NULL,
  `id_empleado` int(11) DEFAULT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL,
  `cargo_id` int(11) DEFAULT NULL,
  `departamento_id` int(11) DEFAULT NULL,
  `jefe_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `log_personal`
--

CREATE TABLE `log_personal` (
  `id` int(11) NOT NULL,
  `fecha_registro` date NOT NULL DEFAULT current_timestamp(),
  `tipo_evento` varchar(50) NOT NULL,
  `descricion` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `personas`
--

CREATE TABLE `personas` (
  `id` int(11) NOT NULL,
  `run_persona` varchar(20) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `apellidos` varchar(100) NOT NULL,
  `id_sexo` int(11) NOT NULL,
  `id_telefonos` int(9) NOT NULL,
  `id_email` int(50) NOT NULL,
  `id_direccion` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `region`
--

CREATE TABLE `region` (
  `id` int(11) NOT NULL,
  `cod_region` varchar(10) DEFAULT NULL,
  `nombre_region` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `region`
--

INSERT INTO `region` (`id`, `cod_region`, `nombre_region`) VALUES
(0, 'RM', 'Region Metropolitana'),
(1, 'I', 'Tarapaca'),
(2, 'II', 'Antofagasta'),
(3, 'III', 'Atacama'),
(4, 'IV', 'Coquimbo'),
(5, 'V', 'Valparaiso'),
(6, 'VI', 'Libertador General B'),
(7, 'VII', 'Maule'),
(8, 'VIII', 'Bio-Bio'),
(9, 'IX', 'Araucania'),
(10, 'X', 'Lagos'),
(11, 'XI', 'Aysen'),
(12, 'XII', 'Region de Magallanes'),
(14, 'XIV', 'Rios'),
(15, 'XV', 'Arica y Parinacota'),
(16, 'XVI', 'Ñuble');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `salud`
--

CREATE TABLE `salud` (
  `id` int(11) NOT NULL,
  `nombre_salud` varchar(50) NOT NULL,
  `descuento` decimal(10,0) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `salud`
--

INSERT INTO `salud` (`id`, `nombre_salud`, `descuento`) VALUES
(0, 'Fonasa', 7),
(2, 'Banmedica S.A', 7),
(3, 'Isalud Ltda.', 7),
(4, 'Colmena Golden Cross S.A.', 7),
(5, 'Consalud S.A.', 7),
(6, 'Cruz Blanca S.A.', 7),
(7, 'Cruz del Norte Ltda.', 7),
(8, 'Nueva Masvida S.A.', 7),
(9, 'Fundación Ltda.', 7),
(10, 'Vida Tres S.A.', 7),
(11, 'Esencial S.A.', 7);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `table2`
--

CREATE TABLE `table2` (
  `nombre_departamento` varchar(100) NOT NULL,
  `descripcion` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `table2`
--

INSERT INTO `table2` (`nombre_departamento`, `descripcion`) VALUES
('Casa Matriz: Los Angeles', 'Av. Las Industrias 4995'),
('Sucursal: Santiago', 'Camino Lo Ruiz 4400, Bodega 8, Renca, Santiago');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `telefono`
--

CREATE TABLE `telefono` (
  `id` int(11) NOT NULL,
  `numero` int(9) NOT NULL,
  `id_persona` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `nombre_usuario` varchar(50) DEFAULT NULL,
  `contrasena` varchar(255) DEFAULT NULL,
  `id_empleado` int(11) DEFAULT NULL,
  `id_cargo` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `afp`
--
ALTER TABLE `afp`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre_afp` (`nombre_afp`);

--
-- Indices de la tabla `cargos`
--
ALTER TABLE `cargos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre_cargo` (`nombre_cargo`);

--
-- Indices de la tabla `ciudades`
--
ALTER TABLE `ciudades`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_comuna` (`id_comuna`);

--
-- Indices de la tabla `comunas`
--
ALTER TABLE `comunas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_region` (`id_region`);

--
-- Indices de la tabla `cotizaciones`
--
ALTER TABLE `cotizaciones`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `departamentos`
--
ALTER TABLE `departamentos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre_departamento` (`nombre_departamento`);

--
-- Indices de la tabla `direcciones`
--
ALTER TABLE `direcciones`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_comuna` (`id_ciudad`),
  ADD UNIQUE KEY `id_ciudad` (`id_ciudad`);

--
-- Indices de la tabla `emails`
--
ALTER TABLE `emails`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `empleados`
--
ALTER TABLE `empleados`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_cotizcion` (`id_cotizacion`),
  ADD UNIQUE KEY `id_afp` (`id_afp`),
  ADD UNIQUE KEY `id_persona` (`id_persona`),
  ADD UNIQUE KEY `id_cotizacion` (`id_cotizacion`),
  ADD UNIQUE KEY `id_estado_personal` (`id_estado_personal`),
  ADD UNIQUE KEY `id_salud` (`id_salud`),
  ADD UNIQUE KEY `id_departamento` (`id_departamento`),
  ADD UNIQUE KEY `id_cargo` (`id_cargo`);

--
-- Indices de la tabla `estado_personal`
--
ALTER TABLE `estado_personal`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `historial_laboral`
--
ALTER TABLE `historial_laboral`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_empleado` (`id_empleado`);

--
-- Indices de la tabla `log_personal`
--
ALTER TABLE `log_personal`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `personas`
--
ALTER TABLE `personas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `run` (`run_persona`),
  ADD UNIQUE KEY `id_direccion` (`id_direccion`),
  ADD UNIQUE KEY `id_telefonos` (`id_telefonos`),
  ADD UNIQUE KEY `id_email` (`id_email`);

--
-- Indices de la tabla `region`
--
ALTER TABLE `region`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `salud`
--
ALTER TABLE `salud`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `table2`
--
ALTER TABLE `table2`
  ADD PRIMARY KEY (`nombre_departamento`);

--
-- Indices de la tabla `telefono`
--
ALTER TABLE `telefono`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_persona` (`id_persona`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre_usuario` (`nombre_usuario`),
  ADD KEY `id_empleado` (`id_empleado`),
  ADD KEY `id_cargo` (`id_cargo`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `afp`
--
ALTER TABLE `afp`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `cargos`
--
ALTER TABLE `cargos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `ciudades`
--
ALTER TABLE `ciudades`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `comunas`
--
ALTER TABLE `comunas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT de la tabla `cotizaciones`
--
ALTER TABLE `cotizaciones`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `departamentos`
--
ALTER TABLE `departamentos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `direcciones`
--
ALTER TABLE `direcciones`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `emails`
--
ALTER TABLE `emails`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `empleados`
--
ALTER TABLE `empleados`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `estado_personal`
--
ALTER TABLE `estado_personal`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `historial_laboral`
--
ALTER TABLE `historial_laboral`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `log_personal`
--
ALTER TABLE `log_personal`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `personas`
--
ALTER TABLE `personas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `region`
--
ALTER TABLE `region`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=102;

--
-- AUTO_INCREMENT de la tabla `salud`
--
ALTER TABLE `salud`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT de la tabla `telefono`
--
ALTER TABLE `telefono`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `ciudades`
--
ALTER TABLE `ciudades`
  ADD CONSTRAINT `ciudades_ibfk_1` FOREIGN KEY (`id_comuna`) REFERENCES `comunas` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `comunas`
--
ALTER TABLE `comunas`
  ADD CONSTRAINT `comunas_ibfk_1` FOREIGN KEY (`id_region`) REFERENCES `region` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `direcciones`
--
ALTER TABLE `direcciones`
  ADD CONSTRAINT `direcciones_ibfk_1` FOREIGN KEY (`id_ciudad`) REFERENCES `ciudades` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `emails`
--
ALTER TABLE `emails`
  ADD CONSTRAINT `emails_ibfk_1` FOREIGN KEY (`id`) REFERENCES `personas` (`id_email`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `empleados`
--
ALTER TABLE `empleados`
  ADD CONSTRAINT `empleados_ibfk_1` FOREIGN KEY (`id_salud`) REFERENCES `salud` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `empleados_ibfk_2` FOREIGN KEY (`id_cotizacion`) REFERENCES `cotizaciones` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `empleados_ibfk_3` FOREIGN KEY (`id_afp`) REFERENCES `afp` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `empleados_ibfk_4` FOREIGN KEY (`id_departamento`) REFERENCES `departamentos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `empleados_ibfk_5` FOREIGN KEY (`id_persona`) REFERENCES `personas` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `empleados_ibfk_6` FOREIGN KEY (`id_cargo`) REFERENCES `cargos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `empleados_ibfk_7` FOREIGN KEY (`id_estado_personal`) REFERENCES `estado_personal` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `historial_laboral`
--
ALTER TABLE `historial_laboral`
  ADD CONSTRAINT `historial_laboral_ibfk_1` FOREIGN KEY (`id_empleado`) REFERENCES `empleados` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `personas`
--
ALTER TABLE `personas`
  ADD CONSTRAINT `personas_ibfk_1` FOREIGN KEY (`id_direccion`) REFERENCES `direcciones` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `personas_ibfk_2` FOREIGN KEY (`id_telefonos`) REFERENCES `telefono` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `usuarios_ibfk_1` FOREIGN KEY (`id_empleado`) REFERENCES `empleados` (`id`),
  ADD CONSTRAINT `usuarios_ibfk_2` FOREIGN KEY (`id_cargo`) REFERENCES `cargos` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
