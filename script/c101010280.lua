--created & coded by Lyris
--SSDスパーク・ツナミ
function c101010280.initial_effect(c)
c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(aux.SynCondition(aux.FilterBoolFunction(Card.IsSetCard,0x167),aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),1,1))
	e0:SetTarget(aux.SynTarget(aux.FilterBoolFunction(Card.IsSetCard,0x167),aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),1,1))
	e0:SetOperation(c101010280.synop)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(c101010280.descon)
	e2:SetOperation(c101010280.desop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(function(e,c) return c==e:GetHandler() end)
	e3:SetCode(EFFECT_ADD_ATTRIBUTE)
	e3:SetValue(ATTRIBUTE_WATER)
	c:RegisterEffect(e3)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c101010280.effcon)
	e1:SetOperation(c101010280.effop)
	c:RegisterEffect(e1)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_BATTLE_DAMAGE)
	e4:SetTarget(c101010280.rectg)
	e4:SetOperation(c101010280.recop)
	c:RegisterEffect(e4)
end
function c101010280.synop(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	Duel.Destroy(g,REASON_MATERIAL+REASON_SYNCHRO,LOCATION_REMOVED)
	g:DeleteGroup()
end
function c101010280.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetTurnPlayer()~=tp and c:IsFaceup() and Duel.GetAttackTarget()==c
end
function c101010280.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function c101010280.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c101010280.effop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,Duel.GetLP(tp)-3000)
end
function c101010280.filter(c)
	return c:IsAttackPos() and c:IsDestructable()
end
function c101010280.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c101010280.filter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	local tg=g:GetMaxGroup(Card.GetAttack)
	if tg then Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,tg:GetFirst():GetAttack()) end
end
function c101010280.recop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c101010280.filter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	if g:GetCount()>0 then
		local tc=nil
		local tg=g:GetMaxGroup(Card.GetAttack)
		if tg:GetCount()>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=tg:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			tc=sg:GetFirst()
		else
			tc=tg:GetFirst()
		end
		local atk=tc:GetAttack()
		if Duel.Destroy(g,REASON_EFFECT)~=0 then
			Duel.Recover(tp,atk,REASON_EFFECT)
		end
	end
end
