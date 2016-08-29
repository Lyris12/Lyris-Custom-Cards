--
function c101010386.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c101010386.ffilter,2,false)
	
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--During either player's turn, if this card was Fusion Summoned: You can destroy this card, then inflict damage to your opponent equal to the total ATK of this card's Fusion Materials. You can only use this effect of "Ignister Dragon" once per turn.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c101010386.mat)
	c:RegisterEffect(e2)
	--damage
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_DESTROYED)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCategory(CATEGORY_DAMAGE)
	e0:SetCountLimit(1,101010386)
	e0:SetLabelObject(e2)
	e0:SetTarget(c101010386.tg)
	e0:SetOperation(c101010386.op)
	c:RegisterEffect(e0)
end
function c101010386.ffilter(c)
	return c:IsRace(RACE_DRAGON) and c:GetBaseAttack()/1000-math.floor(c:GetBaseAttack()/1000)==0
end
function c101010386.mat(e,c)
	local g=c:GetMaterial()
	local atk=0
	local tc=g:GetFirst()
	while tc do
		atk=atk+tc:GetAttack()
		tc=g:GetNext()
	end
	e:SetLabel(atk)
end
function c101010386.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	local dam=1000
	if e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) then dam=dam+e:GetLabelObject():GetLabel() end
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c101010386.op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
