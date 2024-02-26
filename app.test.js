const app = require("./app")
const supertest = require("supertest")
const request = supertest(app)

describe("/ (root endpoint)", () => {
    it("debería responder un hola mundo", async () => {
        const response = await request.get("/")
        expect(response.status).toBe(200)
        expect(response.body.message).toBe("Hola Mundo!");
    })
})