<template>
  <div class="home">

    <el-row>
      <el-button v-for="(user,key) in users" @click="data = user" :key="'u'+key">{{user.name}}</el-button>
    </el-row>
    <el-row>
      {{data.name}}
      <el-input v-model="data.userName"/>
      <el-input v-model="data.password"/>
    </el-row>
    <el-row>
      <el-button @click="chat.connect(data.userName,data.password)">登录</el-button>
      <el-input v-model="send.roomId"/>
      <el-button @click="chat.joinRoom(send.roomId)">加入群聊</el-button>
    </el-row>
    <el-row>
      <el-button v-for="(user,key) in users" @click="send.userName = user.userName" :key="'s'+key">{{user.name}}</el-button>
      <el-button @click="send.userName = send.roomId">群聊</el-button>
      <el-input v-model="send.userName"/>
      <el-input type="textarea" v-model="send.content"/>
      <el-button @click="sendMessage">发送</el-button>
    </el-row>
  </div>
</template>

<script>
import Chat from "../utils/chat"

// const IM_HOST = '10.20.5.122';
const IM_HOST = '10.20.1.134';

const content = "{\"content\":\"asdfasdfasdgasdgasdgasdgasdg\",\"fromUserId\":\"200025114\",\"messageId\":\"f3a9ec2181914e969f92db9669e4b32a\",\"timeSend\":1545980714,\"type\":1}";

export default {

  created(){
    this.chat = new Chat();
    this.chat.on('message',msg => {
      console.log(msg);
    })
  },

  mounted(){
    
    this.data = this.users[0];
    console.log(this.chat);

  },

  data(){
    return {
      data:{
        userName:'',
        password:'',
        name: ''
      },
      users:[{
        // userName:'123@192.168.0.101',
        userName:'123@'+ IM_HOST +'/web',
        password:'123',
        name:'123'
      },{
        // userName:'223@192.168.0.101',
        userName:'223@'+ IM_HOST +'/web',
        password:'223',
        name:'223'
      }],
      send:{
        userName:'',
        content,
        roomId:'64a73088a9ca4990b9a6f362e83454b8@muc.' + IM_HOST,
      }
    }
  },

  methods:{
    sendMessage(){
      if(!this.send.content || !this.send.userName){
        return;
      }
      // this.chat.send(this.send.userName,this.send.content.replace(/"/g,'&quot;'));
      this.chat.send(this.send.userName,this.send.content);
    }
  }

}
</script>
