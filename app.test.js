const app = require("./app")
const server = require("./server")
const supertest = require("supertest")

const request = supertest(app)

it("Debe responder un hola mundo", async () => {
    const response = await request.get("/")
    expect(response.status).toBe(200)
    expect(response.body.message).toBe("Hola Mundo!")
})

afterAll(() => {
    server.closeAll()
});
