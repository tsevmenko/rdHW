Практичне завдання:
Запуск і аналіз вузла Bitcoin

План
Встановити на комп’ютер робоче оточення для запуску Bitcoin-вузла
Встановлення Docker-image Bitcoin-вузла
Запуск мережі
Операції з вузлом

Покрокова інструкція:


Step 1: Install Docker

Windows:
Встановлюємо VirtualBox згідно цьому відео: https://www.youtube.com/watch?v=8mns5yqMfZk
Встановлюємо Ubuntu в наш VirtualBox як в цьому відео: https://www.youtube.com/watch?v=x5MhydijWmc
Заходимо всередину OS Ubuntu, запущеної всередині VirtualBox
Відкриваємо термінал
Вводимо команди


curl -sSl https://get.docker.com/ | sudo sh



Linux

curl -sSl https://get.docker.com/ | sudo sh



Mac
Встановлюємо Docker як в цій інструкції
https://medium.com/crowdbotics/a-complete-one-by-one-guide-to-install-docker-on-your-mac-os-using-homebrew-e818eb4cfc3

Для всіх кому не вийшло налаштувати власноруч:
11.12.2022 від ранку буде працювати спеціальний сервер де я вже все налаштував. Все що потрібно буде вам зробити це підключитись до нього і провести операції в Part 3.

Part 2: Download Bitcoin Node Image
В терміналі ввести

// pull bitcoin node image;
docker pull freewil/bitcoin-testnet-box



Part 3:
// run the image
sudo docker run -it -p 19001:19001 -p 19011:19011 -p 19000:19000 freewil/bitcoin-testnet-box

// this will launch 2 clean bitcoin nodes, connected together
сmake start

// blockchain has no blocks, nodes have no wallets.
// connect to console of first bitcoin node

// check the node wallet. There is none yet
bitcoin-cli -datadir=1 getwalletinfo

// create node wallet
bitcoin-cli -datadir=1 createwallet default

// look at the wallet
bitcoin-cli -datadir=1 getwalletinfo
//notice that keypoolsize is 1000

// the wallet still needs address. Create first address
bitcoin-cli -datadir=1 getnewaddress

// look at the wallet again, notice that keypoolsize is now 999, meaning 1 private key is now used
bitcoin-cli -datadir=1 getwalletinfo

// look at private key for that address
bitcoin-cli -datadir=1 dumpprivkey <address>

// generate first block in blockchain
bitcoin-cli -datadir=1 -generate 1

//check if new block has been added to “blocks” attribute
bitcoin-cli -datadir=1 getblockchaininfo

// switch to other node, view blockchain, it should be the same as in first node
bitcoin-cli -datadir=2 getblockchaininfo

// generate wallet and address on second node
bitcoin-cli -datadir=2 createwallet default
bitcoin-cli -datadir=2 getnewaddress

// generate block from wallet 2
bitcoin-cli -datadir=2 -generate 1

// check current blockchain state. Now we have 2 blocks total
bitcoin-cli -datadir=1 -getblockchain info
bitcoin-cli -datadir=1 getblockchaininfo

// notice that "height" is 2 now, that means the number of blocks in blockchain now

// lets view the last block(number 2)
bitcoin-cli -datadir=1 -getblockstats 2
bitcoin-cli -datadir=1 getblockstats 2

// notice there is only 1 tx inside it - the one that has sent the miner their 50 BTC

// now, lets see if there are any unconfirmed tx in the network now
bitcoin-cli -datadir=1 getrawmempool

// no, mempool is empty

// let's send transaction from wallet 2 to wallet 1
// !!!!! remember to insert your wallet 1 address instead of
“bcrt1qemd8k6ghm76fqdcmk3dhraa2hde5jvk06k5m0j”
bitcoin-cli -datadir=2 -named sendtoaddress address="bcrt1qemd8k6ghm76fqdcmk3dhraa2hde5jvk06k5m0j" amount=0.5 fee_rate=1 subtractfeefromamount=false replaceable=true avoid_reuse=false comment="2 pizzas" comment_to="jeremy" verbose=true

// you can't send tx yet, the balance is still immature
bitcoin-cli -datadir=1 gettransaction "<hash of transaction that you have received"

// you have to generate 99 more blocks to make sure your reward from block 1 is mature
bitcoin-cli -datadir=2 -generate 99

// send transaction from wallet 2 to wallet 1 again

// it is done, but not verified yet. You can find it in the unverified txpool
bitcoin-cli -datadir=2 getrawmempool

// to verify the tx, you need to include it into a new block
// mine the new block!
bitcoin-cli -datadir=2 -generate 1

// check mempool again
bitcoin-cli -datadir=2 getrawmempool

// the tx is gone now! It has been verified and included in last block

// find the tx hash, insert instead of txhash in this command and analyze it
bitcoin-cli -datadir=2 gettransaction “<txhash>”
bitcoin-cli -datadir=12 gettransaction “<txhash>”

//well done! Now you know how btc node works.


https://developer.bitcoin.org/reference/rpc/
https://www.youtube.com/watch?v=icdMEKNIKBc