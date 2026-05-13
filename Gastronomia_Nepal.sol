// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title Gastronomia_Nepal
 * @dev Registro de técnicas de vaporización y grasas de alta montaña.
 * Serie: Sabores de Asia (#14) - Nodo Himalaya
 */
contract Gastronomia_Nepal {

    error RangoExcedido(string parametro, uint256 valor);
    error YaVotado(address voter);
    error IDInvalido(uint256 id);
    error NombreRequerido();

    struct Plato {
        string nombre;
        string ingredientes;
        string preparacion;
        uint256 altitudOptimaCoccion;   // Metros sobre el nivel del mar (1000-8848)
        uint256 resistenciaMasaVapor;   // Escala de elasticidad de la masa (1-100)
        bool utilizaGrasaTermica;       // Validador de uso de Ghee/Yak butter
        uint256 likes;
        uint256 dislikes;
    }

    mapping(uint256 => Plato) public registroCulinario;
    mapping(uint256 => mapping(address => bool)) public hasVoted;
    
    uint256 public totalRegistros;
    address public owner;

    constructor() {
        owner = msg.sender;
        // Inauguramos con el Momo (Ingeniería de Sellado)
        registrarPlato(
            "Momo", 
            "Harina, agua, carne picada o vegetales, jengibre, ajo, pimienta de Sichuan.",
            "Dumplings sellados hermeticamente y cocidos al vapor para retener jugos internos en altitud.",
            1400, 
            85, 
            true
        );
    }

    function registrarPlato(
        string memory _n, 
        string memory _i, 
        string memory _p, 
        uint256 _altitud, 
        uint256 _resistencia,
        bool _grasa
    ) public {
        if (bytes(_n).length == 0) revert NombreRequerido();
        if (_altitud < 1000 || _altitud > 8848) revert RangoExcedido("Altitud", _altitud);
        if (_resistencia > 100) revert RangoExcedido("Resistencia Masa", _resistencia);

        totalRegistros++;
        registroCulinario[totalRegistros] = Plato({
            nombre: _n,
            ingredientes: _i,
            preparacion: _p,
            altitudOptimaCoccion: _altitud,
            resistenciaMasaVapor: _resistencia,
            utilizaGrasaTermica: _grasa,
            likes: 0,
            dislikes: 0
        });
    }

    function darLike(uint256 _id) public {
        if (_id == 0 || _id > totalRegistros) revert IDInvalido(_id);
        if (hasVoted[_id][msg.sender]) revert YaVotado(msg.sender);
        
        registroCulinario[_id].likes++;
        hasVoted[_id][msg.sender] = true;
    }

    function darDislike(uint256 _id) public {
        if (_id == 0 || _id > totalRegistros) revert IDInvalido(_id);
        if (hasVoted[_id][msg.sender]) revert YaVotado(msg.sender);
        
        registroCulinario[_id].dislikes++;
        hasVoted[_id][msg.sender] = true;
    }
}
