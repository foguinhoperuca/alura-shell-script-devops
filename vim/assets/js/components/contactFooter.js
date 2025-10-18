class ContactFooter extends HTMLElement {
    constructor() {
        super();

        const shadowRoot = this.attachShadow({ mode: 'open' });

        const template = document.createElement('template');
        template.innerHTML = `
              <style>
                footer {
                	background-color: #333;
                	color: #FFF;
                	padding: 0 20px;
                	margin-top: 10px;
                    font-size: 14px;
                    display: flex;
                    justify-content: space-between;
                }

                footer div {
                    text-align: right;
                }

                footer address:last-child {
                	margin-bottom: 0;
                }
              </style>
              <footer>
                <address>
                    <h3>
                        Tire o seu projeto do papel! <br/>
                        <small>Fale conosco para um orçamento.</small>
                    </h3>
                    <strong>TopCasaFina Arquitetura</strong><br>
                    <strong>E-mail:</strong> contato.topcasafina@alura.com.br <br />
                    <strong>Telefone:</strong> 15-99177-5566<br />
                    <strong>Pager:</strong> 8468465219<br />
                    <strong>Fax:</strong> +44-12-45678912<br />
                </address>
                <div>
                    <h3>Parceiros e Fornecedores</h3>
                    TopMassa Fina Construções<br />
                    Pedro Cimentos <br />
                    Simão Móveis Planejados<br />
                </div>
              </footer>
        `;

        shadowRoot.appendChild(template.content.cloneNode(true));
    }
}

customElements.define('contact-footer', ContactFooter);
