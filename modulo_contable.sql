-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 13-02-2024 a las 14:57:55
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
-- Base de datos: `modulo_contable`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `calcular_iva` (IN `monto` DECIMAL(10), OUT `iva` DECIMAL(10), OUT `neto` DECIMAL(10), OUT `total` DECIMAL(10))   BEGIN
      -- Calcula el neto
    SET neto = monto;
    
    -- Calcula el IVA (porcentaje del 19%)
    SET iva = monto * 0.19;

    -- Calcula el total
    SET total = monto * 1.19;

    -- Muestra los resultados 
    SELECT CONCAT('Monto Ingresado: $', FORMAT(monto, 0)) AS 'Valor Monto';
    SELECT CONCAT('Neto: $', FORMAT(neto, 0)) AS 'Neto';
    SELECT CONCAT('IVA (19%): $', FORMAT(iva, 0)) AS 'IVA (19%)';
    SELECT CONCAT('Total: $', FORMAT(total, 0)) AS 'Total';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `gestionar_clientes` (IN `accion` VARCHAR(10), IN `id_cliente` INT, IN `nombre_cliente` VARCHAR(255), IN `rut` VARCHAR(20), IN `giro` VARCHAR(25), IN `direccion` VARCHAR(20), IN `comuna` VARCHAR(10), IN `telefono` VARCHAR(20), IN `email` VARCHAR(255))   BEGIN
    -- Verificar la acción solicitada
    IF accion = 'insertar' THEN
        -- Insertar un nuevo cliente
        INSERT INTO clientes (nombre_cliente, rut, giro, direccion, comuna, telefono, email)
        VALUES (nombre_cliente, rut,  giro, direccion, comuna, telefono, email);
        SELECT 'Nuevo cliente insertado correctamente.' AS mensaje;
    ELSEIF accion = 'obtener' THEN
        -- Obtener información de un cliente específico
        SELECT * FROM clientes WHERE id = id_cliente;
    ELSEIF accion = 'listar' THEN
        -- Listar todos los clientes
        SELECT * FROM clientes;
    ELSE
        -- Acción no válida
        SELECT 'Acción no válida. Utiliza "insertar", "obtener" o "listar".' AS mensaje;
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `boletas`
--

CREATE TABLE `boletas` (
  `id` int(11) NOT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `fecha_emision` date DEFAULT NULL,
  `monto_total` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes`
--

CREATE TABLE `clientes` (
  `id` int(11) NOT NULL,
  `nombre_cliente` varchar(255) DEFAULT NULL,
  `rut` varchar(20) DEFAULT NULL,
  `giro` varchar(25) DEFAULT NULL,
  `direccion` varchar(20) DEFAULT NULL,
  `comuna` varchar(10) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `clientes`
--

INSERT INTO `clientes` (`id`, `nombre_cliente`, `rut`, `giro`, `direccion`, `comuna`, `telefono`, `email`) VALUES
(1, 'Cabañas Mi Casa', '12153457-6', 'Otros tipos de hospedaje ', 'Saltos del Lajas', 'Los Angele', '994987460', 'turismomicasa@gmail.com');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes_divisas`
--

CREATE TABLE `clientes_divisas` (
  `id` int(11) NOT NULL,
  `rut_cliente` varchar(20) NOT NULL,
  `id_divisas` int(11) NOT NULL,
  `nombre_cliente` varchar(255) NOT NULL,
  `codigo_moneda` varchar(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_boleta`
--

CREATE TABLE `detalle_boleta` (
  `id` int(11) NOT NULL,
  `id_boleta` int(11) DEFAULT NULL,
  `id_objeto` int(11) DEFAULT NULL,
  `cantidad` int(11) DEFAULT NULL,
  `subtotal` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_factura`
--

CREATE TABLE `detalle_factura` (
  `id` int(11) NOT NULL,
  `id_factura` int(11) DEFAULT NULL,
  `id_objeto` int(11) DEFAULT NULL,
  `cantidad` int(11) DEFAULT NULL,
  `subtotal` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_nota_credito`
--

CREATE TABLE `detalle_nota_credito` (
  `id` int(11) NOT NULL,
  `id_nota_credito` int(11) DEFAULT NULL,
  `id_detalle_factura` int(11) DEFAULT NULL,
  `monto_devuelto` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `divisas`
--

CREATE TABLE `divisas` (
  `id` int(11) NOT NULL,
  `codigo_moneda` varchar(3) DEFAULT NULL,
  `nombre_moneda` varchar(50) DEFAULT NULL,
  `simbolo_moneda` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `divisas`
--

INSERT INTO `divisas` (`id`, `codigo_moneda`, `nombre_moneda`, `simbolo_moneda`) VALUES
(1, 'CLP', 'Peso chileno', '$'),
(2, 'USD', 'Dólar estadounidense', '$'),
(3, 'EUR', 'Euro', '€');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `facturas`
--

CREATE TABLE `facturas` (
  `id` int(11) NOT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `giro_cliente` varchar(25) DEFAULT NULL,
  `direccion_cliente` varchar(20) DEFAULT NULL,
  `comuna_cliente` varchar(10) DEFAULT NULL,
  `fecha_emision` date DEFAULT NULL,
  `telefono_cliente` varchar(20) DEFAULT NULL,
  `cond_venta` varchar(10) DEFAULT NULL,
  `id_divisa` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `guias_despacho`
--

CREATE TABLE `guias_despacho` (
  `id` int(11) NOT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `fecha_emision` date DEFAULT NULL,
  `id_ubicacion_origen` int(11) DEFAULT NULL,
  `id_ubicacion_destino` int(11) DEFAULT NULL,
  `id_vehiculo` int(11) DEFAULT NULL,
  `estado` varchar(50) DEFAULT NULL,
  `comentarios` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `log`
--

CREATE TABLE `log` (
  `id` int(11) NOT NULL,
  `fecha_registro` timestamp NOT NULL DEFAULT current_timestamp(),
  `tipo_evento` varchar(50) NOT NULL,
  `descripcion` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `log`
--

INSERT INTO `log` (`id`, `fecha_registro`, `tipo_evento`, `descripcion`) VALUES
(1, '2024-02-02 19:51:09', 'EVENTO_IMPORTANTE', 'Se realizó una acción importante en el sistema.');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `notas_credito`
--

CREATE TABLE `notas_credito` (
  `id` int(11) NOT NULL,
  `id_factura` int(11) DEFAULT NULL,
  `fecha_emision` date DEFAULT NULL,
  `monto_total` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `objetos`
--

CREATE TABLE `objetos` (
  `id` int(11) NOT NULL,
  `nombre_objeto` varchar(255) DEFAULT NULL,
  `precio_unitario` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ordenes_compra`
--

CREATE TABLE `ordenes_compra` (
  `id` int(11) NOT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `fecha_emision` date DEFAULT NULL,
  `monto_total` decimal(10,2) DEFAULT NULL,
  `estado` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `boletas`
--
ALTER TABLE `boletas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_cliente` (`id_cliente`);

--
-- Indices de la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `rut` (`rut`);

--
-- Indices de la tabla `clientes_divisas`
--
ALTER TABLE `clientes_divisas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`),
  ADD UNIQUE KEY `id_divisas_2` (`id_divisas`),
  ADD UNIQUE KEY `rut_cliente_2` (`rut_cliente`),
  ADD KEY `rut_cliente` (`rut_cliente`),
  ADD KEY `id_divisas` (`id_divisas`);

--
-- Indices de la tabla `detalle_boleta`
--
ALTER TABLE `detalle_boleta`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_boleta` (`id_boleta`),
  ADD KEY `id_objeto` (`id_objeto`);

--
-- Indices de la tabla `detalle_factura`
--
ALTER TABLE `detalle_factura`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_factura` (`id_factura`),
  ADD KEY `id_objeto` (`id_objeto`);

--
-- Indices de la tabla `detalle_nota_credito`
--
ALTER TABLE `detalle_nota_credito`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_nota_credito` (`id_nota_credito`),
  ADD KEY `id_detalle_factura` (`id_detalle_factura`);

--
-- Indices de la tabla `divisas`
--
ALTER TABLE `divisas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `codigo_moneda` (`codigo_moneda`);

--
-- Indices de la tabla `facturas`
--
ALTER TABLE `facturas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_cliente` (`id_cliente`);

--
-- Indices de la tabla `guias_despacho`
--
ALTER TABLE `guias_despacho`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `log`
--
ALTER TABLE `log`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `notas_credito`
--
ALTER TABLE `notas_credito`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_factura` (`id_factura`);

--
-- Indices de la tabla `objetos`
--
ALTER TABLE `objetos`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `ordenes_compra`
--
ALTER TABLE `ordenes_compra`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_cliente` (`id_cliente`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `boletas`
--
ALTER TABLE `boletas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `clientes`
--
ALTER TABLE `clientes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `clientes_divisas`
--
ALTER TABLE `clientes_divisas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `detalle_boleta`
--
ALTER TABLE `detalle_boleta`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `detalle_factura`
--
ALTER TABLE `detalle_factura`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `detalle_nota_credito`
--
ALTER TABLE `detalle_nota_credito`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `divisas`
--
ALTER TABLE `divisas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `facturas`
--
ALTER TABLE `facturas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `guias_despacho`
--
ALTER TABLE `guias_despacho`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `log`
--
ALTER TABLE `log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `notas_credito`
--
ALTER TABLE `notas_credito`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `objetos`
--
ALTER TABLE `objetos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `ordenes_compra`
--
ALTER TABLE `ordenes_compra`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `boletas`
--
ALTER TABLE `boletas`
  ADD CONSTRAINT `boletas_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id`);

--
-- Filtros para la tabla `clientes_divisas`
--
ALTER TABLE `clientes_divisas`
  ADD CONSTRAINT `clientes_divisas_ibfk_1` FOREIGN KEY (`id_divisas`) REFERENCES `divisas` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `clientes_divisas_ibfk_2` FOREIGN KEY (`rut_cliente`) REFERENCES `clientes` (`rut`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `detalle_boleta`
--
ALTER TABLE `detalle_boleta`
  ADD CONSTRAINT `detalle_boleta_ibfk_1` FOREIGN KEY (`id_boleta`) REFERENCES `boletas` (`id`),
  ADD CONSTRAINT `detalle_boleta_ibfk_2` FOREIGN KEY (`id_objeto`) REFERENCES `objetos` (`id`);

--
-- Filtros para la tabla `detalle_factura`
--
ALTER TABLE `detalle_factura`
  ADD CONSTRAINT `detalle_factura_ibfk_1` FOREIGN KEY (`id_factura`) REFERENCES `facturas` (`id`),
  ADD CONSTRAINT `detalle_factura_ibfk_2` FOREIGN KEY (`id_objeto`) REFERENCES `objetos` (`id`);

--
-- Filtros para la tabla `detalle_nota_credito`
--
ALTER TABLE `detalle_nota_credito`
  ADD CONSTRAINT `detalle_nota_credito_ibfk_1` FOREIGN KEY (`id_nota_credito`) REFERENCES `notas_credito` (`id`),
  ADD CONSTRAINT `detalle_nota_credito_ibfk_2` FOREIGN KEY (`id_detalle_factura`) REFERENCES `detalle_factura` (`id`);

--
-- Filtros para la tabla `facturas`
--
ALTER TABLE `facturas`
  ADD CONSTRAINT `facturas_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id`);

--
-- Filtros para la tabla `notas_credito`
--
ALTER TABLE `notas_credito`
  ADD CONSTRAINT `notas_credito_ibfk_1` FOREIGN KEY (`id_factura`) REFERENCES `facturas` (`id`);

--
-- Filtros para la tabla `ordenes_compra`
--
ALTER TABLE `ordenes_compra`
  ADD CONSTRAINT `ordenes_compra_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
