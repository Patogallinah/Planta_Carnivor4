-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 13-02-2024 a las 14:58:17
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
-- Base de datos: `modulo_cross_docking`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `armado_pedidos`
--

CREATE TABLE `armado_pedidos` (
  `id` int(11) NOT NULL,
  `id_recepcion_bodegaTSV` int(11) DEFAULT NULL,
  `fecha_armado` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `carga_mercaderia`
--

CREATE TABLE `carga_mercaderia` (
  `id` int(11) NOT NULL,
  `id_mercaderia` int(11) DEFAULT NULL,
  `fecha_carga` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `carga_mercaderia_picking`
--

CREATE TABLE `carga_mercaderia_picking` (
  `id` int(11) NOT NULL,
  `id_armado_pedido` int(11) DEFAULT NULL,
  `fecha_carga` date DEFAULT NULL,
  `detalle_facturas` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes`
--

CREATE TABLE `clientes` (
  `id` int(11) NOT NULL,
  `nombre` varchar(255) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `documentacion`
--

CREATE TABLE `documentacion` (
  `id` int(11) NOT NULL,
  `id_mercaderia` int(11) DEFAULT NULL,
  `fecha_entrega_documentos` date DEFAULT NULL,
  `tipo_documento` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `entrega_documentacion`
--

CREATE TABLE `entrega_documentacion` (
  `id` int(11) NOT NULL,
  `id_carga_mercaderia` int(11) DEFAULT NULL,
  `fecha_entrega_documento` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `envio_facturas`
--

CREATE TABLE `envio_facturas` (
  `id` int(11) NOT NULL,
  `id_facturacion` int(11) DEFAULT NULL,
  `fecha_envio` date DEFAULT NULL,
  `metodo_envio` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `facturacion`
--

CREATE TABLE `facturacion` (
  `id` int(11) NOT NULL,
  `id_recepcion_documentacion` int(11) DEFAULT NULL,
  `fecha_facturacion` date DEFAULT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `monto_total` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `facturas`
--

CREATE TABLE `facturas` (
  `id` int(11) NOT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `fecha_emision` date DEFAULT NULL,
  `monto` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ingreso_bodega`
--

CREATE TABLE `ingreso_bodega` (
  `id` int(11) NOT NULL,
  `id_carga_mercaderia` int(11) DEFAULT NULL,
  `fecha_ingreso` date DEFAULT NULL,
  `etiqueta_adhesiva` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mercaderia`
--

CREATE TABLE `mercaderia` (
  `id` int(11) NOT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `fecha_entrega` date DEFAULT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `id_tipo_mercaderia` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `recepcion_bodegatsv`
--

CREATE TABLE `recepcion_bodegatsv` (
  `id` int(11) NOT NULL,
  `id_ingreso_bodega` int(11) DEFAULT NULL,
  `fecha_recepcion` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `recepcion_documentacion`
--

CREATE TABLE `recepcion_documentacion` (
  `id` int(11) NOT NULL,
  `id_carga_mercaderia_picking` int(11) DEFAULT NULL,
  `fecha_recepcion` date DEFAULT NULL,
  `observaciones` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `revision_facturas`
--

CREATE TABLE `revision_facturas` (
  `id` int(11) NOT NULL,
  `id_factura` int(11) DEFAULT NULL,
  `fecha_recepcion` date DEFAULT NULL,
  `Observaciones` text DEFAULT NULL,
  `id_estado` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `revision_inhouse`
--

CREATE TABLE `revision_inhouse` (
  `id` int(11) NOT NULL,
  `id_mercaderia` int(11) DEFAULT NULL,
  `fecha_revisión` date DEFAULT NULL,
  `observaciones` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `armado_pedidos`
--
ALTER TABLE `armado_pedidos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_recepcion_bodegaTSV` (`id_recepcion_bodegaTSV`);

--
-- Indices de la tabla `carga_mercaderia`
--
ALTER TABLE `carga_mercaderia`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_mercaderia` (`id_mercaderia`);

--
-- Indices de la tabla `carga_mercaderia_picking`
--
ALTER TABLE `carga_mercaderia_picking`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_armado_pedido` (`id_armado_pedido`);

--
-- Indices de la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `documentacion`
--
ALTER TABLE `documentacion`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_mercaderia` (`id_mercaderia`);

--
-- Indices de la tabla `entrega_documentacion`
--
ALTER TABLE `entrega_documentacion`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_carga_mercaderia` (`id_carga_mercaderia`);

--
-- Indices de la tabla `envio_facturas`
--
ALTER TABLE `envio_facturas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_facturacion` (`id_facturacion`);

--
-- Indices de la tabla `facturacion`
--
ALTER TABLE `facturacion`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_recepcion_documentacion` (`id_recepcion_documentacion`),
  ADD KEY `id_cliente` (`id_cliente`);

--
-- Indices de la tabla `facturas`
--
ALTER TABLE `facturas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_cliente` (`id_cliente`);

--
-- Indices de la tabla `ingreso_bodega`
--
ALTER TABLE `ingreso_bodega`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_carga_mercaderia` (`id_carga_mercaderia`);

--
-- Indices de la tabla `mercaderia`
--
ALTER TABLE `mercaderia`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_tipo_mercaderia` (`id_tipo_mercaderia`),
  ADD KEY `id_cliente` (`id_cliente`);

--
-- Indices de la tabla `recepcion_bodegatsv`
--
ALTER TABLE `recepcion_bodegatsv`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_ingreso_bodega` (`id_ingreso_bodega`);

--
-- Indices de la tabla `recepcion_documentacion`
--
ALTER TABLE `recepcion_documentacion`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_carga_mercaderia_picking` (`id_carga_mercaderia_picking`);

--
-- Indices de la tabla `revision_facturas`
--
ALTER TABLE `revision_facturas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_estado` (`id_estado`),
  ADD KEY `id_factura` (`id_factura`);

--
-- Indices de la tabla `revision_inhouse`
--
ALTER TABLE `revision_inhouse`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_mercaderia` (`id_mercaderia`);

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `armado_pedidos`
--
ALTER TABLE `armado_pedidos`
  ADD CONSTRAINT `armado_pedidos_ibfk_1` FOREIGN KEY (`id_recepcion_bodegaTSV`) REFERENCES `recepcion_bodegatsv` (`id`);

--
-- Filtros para la tabla `carga_mercaderia`
--
ALTER TABLE `carga_mercaderia`
  ADD CONSTRAINT `carga_mercaderia_ibfk_1` FOREIGN KEY (`id_mercaderia`) REFERENCES `mercaderia` (`id`);

--
-- Filtros para la tabla `carga_mercaderia_picking`
--
ALTER TABLE `carga_mercaderia_picking`
  ADD CONSTRAINT `carga_mercaderia_picking_ibfk_1` FOREIGN KEY (`id_armado_pedido`) REFERENCES `armado_pedidos` (`id`);

--
-- Filtros para la tabla `documentacion`
--
ALTER TABLE `documentacion`
  ADD CONSTRAINT `documentacion_ibfk_1` FOREIGN KEY (`id_mercaderia`) REFERENCES `mercaderia` (`id`);

--
-- Filtros para la tabla `entrega_documentacion`
--
ALTER TABLE `entrega_documentacion`
  ADD CONSTRAINT `entrega_documentacion_ibfk_1` FOREIGN KEY (`id_carga_mercaderia`) REFERENCES `carga_mercaderia` (`id`);

--
-- Filtros para la tabla `envio_facturas`
--
ALTER TABLE `envio_facturas`
  ADD CONSTRAINT `envio_facturas_ibfk_1` FOREIGN KEY (`id_facturacion`) REFERENCES `facturacion` (`id`);

--
-- Filtros para la tabla `facturacion`
--
ALTER TABLE `facturacion`
  ADD CONSTRAINT `facturacion_ibfk_1` FOREIGN KEY (`id_recepcion_documentacion`) REFERENCES `recepcion_documentacion` (`id`),
  ADD CONSTRAINT `facturacion_ibfk_2` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id`);

--
-- Filtros para la tabla `facturas`
--
ALTER TABLE `facturas`
  ADD CONSTRAINT `facturas_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id`);

--
-- Filtros para la tabla `ingreso_bodega`
--
ALTER TABLE `ingreso_bodega`
  ADD CONSTRAINT `ingreso_bodega_ibfk_1` FOREIGN KEY (`id_carga_mercaderia`) REFERENCES `carga_mercaderia` (`id`);

--
-- Filtros para la tabla `mercaderia`
--
ALTER TABLE `mercaderia`
  ADD CONSTRAINT `mercaderia_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id`);

--
-- Filtros para la tabla `recepcion_bodegatsv`
--
ALTER TABLE `recepcion_bodegatsv`
  ADD CONSTRAINT `recepcion_bodegatsv_ibfk_1` FOREIGN KEY (`id_ingreso_bodega`) REFERENCES `ingreso_bodega` (`id`);

--
-- Filtros para la tabla `recepcion_documentacion`
--
ALTER TABLE `recepcion_documentacion`
  ADD CONSTRAINT `recepcion_documentacion_ibfk_1` FOREIGN KEY (`id_carga_mercaderia_picking`) REFERENCES `carga_mercaderia_picking` (`id`);

--
-- Filtros para la tabla `revision_facturas`
--
ALTER TABLE `revision_facturas`
  ADD CONSTRAINT `revision_facturas_ibfk_1` FOREIGN KEY (`id_factura`) REFERENCES `facturas` (`id`),
  ADD CONSTRAINT `revision_facturas_ibfk_2` FOREIGN KEY (`id_estado`) REFERENCES `estado` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `revision_inhouse`
--
ALTER TABLE `revision_inhouse`
  ADD CONSTRAINT `revision_inhouse_ibfk_1` FOREIGN KEY (`id_mercaderia`) REFERENCES `mercaderia` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
