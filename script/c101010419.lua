--created & coded by Lyris
--機夜行襲雷竜－モーニング
function c101010419.initial_effect(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetTarget(c101010419.atcon)
	e0:SetRange(0xf3)
	e0:SetTargetRange(0xf3,0)
	e0:SetCode(EFFECT_ADD_ATTRIBUTE)
	e0:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(c101010419.fscondition)
	e1:SetOperation(c101010419.fsoperation)
	c:RegisterEffect(e1)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c101010419.succon)
	e4:SetOperation(c101010419.sucop)
	c:RegisterEffect(e4)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e3:SetCondition(c101010419.hcon)
	e3:SetOperation(c101010419.hop)
	c:RegisterEffect(e3)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(c101010419.descon)
	e2:SetOperation(c101010419.desop)
	c:RegisterEffect(e2)
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_POSITION)
	e5:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_ATTACK_ANNOUNCE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c101010419.poscon)
	e5:SetTarget(c101010419.postg)
	e5:SetOperation(c101010419.posop)
	c:RegisterEffect(e5)
end
function c101010419.atcon(e,c)
	return c==e:GetHandler()
end
function c101010419.poscon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return d and a:IsControler(tp) and a:IsSetCard(0x167)
end
function c101010419.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	local g=Duel.GetAttackTarget()
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c101010419.filter(c)
	return c:IsSetCard(0x167)
end
function c101010419.posop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,true)~=0 and c101010419.filter(a) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PIERCE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		a:RegisterEffect(e1)
	end
end
function c101010419.fscondition(e,g,gc,chkf)
	if g==nil then return false end
	if gc then
		local mg=g:Filter(Card.IsFusionSetCard,nil,0x167)
		mg:AddCard(gc)
		return gc:IsFusionSetCard(0x167) and mg:GetClassCount(Card.GetCode)>1
	end
	local fs=false
	local mg=g:Filter(Card.IsFusionSetCard,nil,0x167)
	if mg:IsExists(aux.FConditionCheckF,1,nil,chkf) then fs=true end
	return mg:GetClassCount(Card.GetCode)>1 and (fs or chkf==PLAYER_NONE)
end
function c101010419.fsoperation(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	if gc then
		local sg=eg:Filter(Card.IsFusionSetCard,gc,0x167)
		sg:Remove(Card.IsCode,nil,gc:GetCode())
		local g=Group.CreateGroup()
		while sg:IsExists(Card.IsFusionSetCard,nil,0x167) do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			g:Merge(sg:Select(tp,1,1,nil))
			sg:Remove(Card.IsCode,nil,g:GetFirst():GetCode())
			if sg:FilterCount(Card.IsFusionSetCard,nil,0x167)==0 or not Duel.SelectYesNo(tp,aux.Stringid(101010038,0)) then break end
		end
		Duel.SetFusionMaterial(g)
		return
	end
	local sg=eg:Filter(Card.IsFusionSetCard,nil,0x167)
	local g1=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	if chkf~=PLAYER_NONE then g1=sg:FilterSelect(tp,aux.FConditionCheckF,1,1,nil,chkf)
	else g1=sg:Select(tp,1,1,nil) end
	sg:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
	local g2=Group.CreateGroup()
	while sg:IsExists(Card.IsFusionSetCard,1,nil,0x167) do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		g2:Merge(sg:Select(tp,1,1,nil))
		sg:Remove(Card.IsCode,nil,g2:GetFirst():GetCode())
		if sg:FilterCount(Card.IsFusionSetCard,nil,0x167)==0 or not Duel.SelectYesNo(tp,aux.Stringid(101010038,0)) then break end
	end
	g1:Merge(g2)
	Duel.SetFusionMaterial(g1)
end
function c101010419.succon(e)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c101010419.sucop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=0
	local def=0
	local g=c:GetMaterial()
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			local au=tc:GetAttack()
			local du=tc:GetDefense()
			if tc:IsPreviousLocation(LOCATION_MZONE) then
				au=tc:GetPreviousAttackOnField()
				du=tc:GetPreviousDefenseOnField()
			end
			atk=atk+au
			def=def+du
			tc=g:GetNext()
		end
		atk=math.floor(atk/2)
		def=math.floor(def/2)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_BASE_DEFENSE)
		e2:SetValue(def)
		c:RegisterEffect(e2)
	end
end
function c101010419.hcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and bit.band(c:GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION and c:IsAttackAbove(3000)
end
function c101010419.hop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev/2)
end
function c101010419.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetTurnPlayer()~=tp and c:IsFaceup() and Duel.GetAttackTarget()==c
end
function c101010419.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
