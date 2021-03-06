# encoding: utf-8

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  mount_uploader :avatar, AvatarUploader

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :name, :user_type, :password,
                  :password_confirmation, :remember_me, :avatar

  validates :name,:presence => true,:uniqueness => true
  validates :user_type, :presence => { :message => "请选择用户类型" }

  has_many :collections, :dependent => :destroy
  has_many :designs,:through => :collections, :dependent => :destroy
  has_many :comments,:through => :designs, :dependent => :destroy
  has_many :tags,:through => :designs

  after_save :create_default_collection


  private

  def create_default_collection
    self.collections.create(name:"#{self.name}的灵感")
  end

end

