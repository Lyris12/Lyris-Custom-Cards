--Rusted Twin Dragon
function c101020112.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeRep(c,101020108,2,false,false)
	--This card can attack all monsters your opponent controls, once each.
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_ATTACK_ALL)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	--Once per turn, when this card declares an attack on an opponent's monster: You can change the battle position of that opponent's monster. (Flip monsters' effects are not activated at this time.)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101020112,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCountLimit(1)
	e1:SetTarget(c101020112.drtg)
	e1:SetOperation(c101020112.drop)
	c:RegisterEffect(e1)
end
function c101020112.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetAttackTarget()
	if chk==0 then return g~=nil end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c101020112.drop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttackTarget()
	if tc:IsRelateToBattle() then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,true)
	end
end
