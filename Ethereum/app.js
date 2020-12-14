var Tx=require('ethereumjs-tx').Transaction
const Web3=require('web3')
const web3= new Web3('https://ropsten.infura.io/v3/750e24348b9e4496a13934284a5509c5')

const account1='0xf55CC4c5fA5e838fFa9a63CAd1DB809F6efeEa04'
const account2='0x32F62B3D54fE7eb3666b959F5A0b3e44B9Cd8aC6'

const privateKey1=Buffer.from(process.env.PRIVATE_KEY_1,'hex')
const privateKey2=Buffer.from(process.env.PRIVATE_KEY_2,'hex')

web3.eth.getBalance(account1,(err,balance) => {
    console.log('account1 balance:',web3.utils.fromWei(balance,'ether'))
})

web3.eth.getBalance(account2,(err,balance) => {
    console.log('account2 balance:',web3.utils.fromWei(balance,'ether'))
})


// Build The Transactions
web3.eth.getTransactionCount(account1,(err,txCount)=>{

    const txObject={
        nonce:web3.utils.toHex(txCount),
        to:account2,
        value:web3.utils.toHex(web3.utils.toWei('1','ether')),
        gasLimit:web3.utils.toHex(21000),
        gasPrice:web3.utils.toHex(web3.utils.toWei('10','gwei'))
        }
        //console.log(txObject)

// Sign The Transaction

//const tx=new Tx(txObject)
const tx = new Tx(txObject, {'chain':'ropsten'})
tx.sign(privateKey1)

const serializedTransaction=tx.serialize()
const raw='0x'+serializedTransaction.toString('hex')

// Broadcast the transaction
web3.eth.sendSignedTransaction(raw,(err,txHash) => {
    console.log('txHash:',txHash)
})

})
