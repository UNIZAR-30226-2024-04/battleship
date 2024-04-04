// Lista de puntos de experiencia a obtener por nivel
const niveles = [10, 50, 100, 200, 500, 1000];

/** 
 * @description Calcula el nivel de un usuario a partir de sus puntos de experiencia
 * @param {number} puntos - Puntos de experiencia del usuario
 * @returns {number} - Nivel del usuario
*/
function calcularNivel(puntos) {
    let nivel = 1;
    let restantes = puntos;
    for (let i = 0; i < niveles.length; i++) {
        if (restantes >= niveles[i]) {
            nivel++;
            restantes -= niveles[i];
        } else break;
    }
    return nivel;
};

module.exports = { calcularNivel, niveles };