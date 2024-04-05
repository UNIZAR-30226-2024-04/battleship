const app = require("./app");
const server = require("./server");
const supertest = require("supertest");
const mongoose = require('mongoose');
const Persona = require('./models/Persona'); // Asume que tienes un modelo Mongoose para 'Persona'
const request = supertest(app);

describe("Tests BD", () => {
  beforeAll(async () => {
    // Limpia la colección 'personas' antes de las pruebas
    await Persona.deleteMany({});
    // Inserta un documento de prueba en la colección 'personas'
    await Persona.create({ name: "Amanda", surname: "Atkinson" });
  });

  it("Responde en /personas con la persona de prueba que acabamos de insertar en la BD", async () => {
    const response = await request.get("/personas");
    expect(response.status).toBe(200);
    expect(response.body.message).toContainEqual({ name: "Amanda", surname: "Atkinson" });
  });

  it("Debe responder un hola mundo", async () => {
    const response = await request.get("/");
    expect(response.status).toBe(200);
    expect(response.body.message).toBe("Hola Mundo!");
  });

  afterAll(() => {
    server.closeAll();
  });
});