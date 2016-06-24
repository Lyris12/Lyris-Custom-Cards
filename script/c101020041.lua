--プラズマ・スラッシュ・ブレイド
local id,ref=GIR()
function ref.start(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(ref.target)
	e1:SetOperation(ref.operation)
	c:RegisterEffect(e1)
	--equip limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EQUIP_LIMIT)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--Pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e2)
	--pulverize
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetCondition(ref.rmcon)
	e3:SetTarget(ref.rmtg)
	e3:SetOperation(ref.rmop)
	c:RegisterEffect(e3)
end
function ref.filter(c)
	return c:IsFaceup()
end
function ref.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function ref.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(ref.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:RandomSelect(tp,1):GetFirst()
	if tc then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function ref.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function ref.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler():GetEquipTarget()
	local a=Duel.GetAttacker()
	local t=Duel.GetAttackTarget()
	if chk==0 then return c==a and t~=nil and t:IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,t,1,0,0)
end
function ref.rmop(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	if d then
		Duel.Remove(d,POS_FACEUP,REASON_EFFECT)
	end
end
