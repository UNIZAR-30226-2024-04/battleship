import React from 'react'

export function Home2() {
    return (
      <div>
        <h1>Home2</h1>
        <p>This is the Home2 page</p>
        <Form />
      </div>
    )
}

class Form extends React.Component {
    constructor(props) {
      super(props)
      this.state = {
        name: '',
      }
    }
  
    render() {
      const { name } = this.state
  
      return (
        <div>
          <h1>Simple form</h1>
          <form>
            <label for>
              Name:
              <input
                type="text"
                value={name}
                onChange={(e) => this.setState({ name: e.target.value })}
              />
            </label>
          </form>
  
          <div>
            <h2>Values of the form</h2>
            <p>Name: {this.state.name}</p>
          </div>
        </div>
      )
    }
  }
  